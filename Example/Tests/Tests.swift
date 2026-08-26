import XCTest
import UIKit
import EditorJSKit

///
private struct TestHeaderStyle: EJHeaderBlockStyle {
    let headerFont: UIFont
    let blockInsets: UIEdgeInsets

    init(headerFont: UIFont, blockInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)) {
        self.headerFont = headerFont
        self.blockInsets = blockInsets
    }

    var alignment: NSTextAlignment { .left }
    var insets: UIEdgeInsets { blockInsets }
    func font(forHeaderLevel level: Int) -> UIFont { headerFont }
    func topInset(forHeaderLevel level: Int) -> CGFloat { .zero }
    func bottomInset(forHeaderLevel level: Int) -> CGFloat { .zero }
}

/// A custom block, defined the way a consumer would define one.
private enum TestBlockType: String, EJAbstractBlockType {
    case testCallout
}

/// A reference type so a test can observe whether the renderer prepared it.
private final class TestCalloutContentItem: EJAbstractBlockContentItem {
    let text: String
    private(set) var prepareCount = 0

    enum CodingKeys: String, CodingKey { case text }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
    }

    func prepareCaches(withStyle style: EJBlockStyle?) {
        prepareCount += 1
    }
}

/// Stands in for a client that overrides sizing, which stops the library's own
/// `sizeForItemAt` — and therefore its cache warming — from ever running.
private final class FixedSizeDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 320, height: 44)
    }
}

///
private final class TestCalloutContentView: UIView, EJBlockView {
    typealias BlockContentItem = TestCalloutContentItem

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(withItem item: TestCalloutContentItem, style: EJBlockStyle?) {
        label.text = "custom:" + item.text
    }

    static func estimatedSize(for item: TestCalloutContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        CGSize(width: boundingWidth, height: 44)
    }
}

class Tests: XCTestCase, EJCollectionDataSource {

    var data: EJBlocksList?

    private var savedHeaderStyle: EJBlockStyle?
    private var savedCustomBlocks: [EJAbstractCustomBlock] = []

    private let headerJSON = #"""
    {"time":1,"version":"2.13.2","blocks":[{"type":"header","data":{"text":"<b>Hello</b> world","level":1}}]}
    """#

    /// These tests mutate the `EJKit.shared` singleton, so its state is captured and restored
    /// around each one — otherwise they leak into each other and results depend on run order.
    override func setUp() {
        super.setUp()
        savedHeaderStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.header)
        savedCustomBlocks = EJKit.shared.registeredCustomBlocks
    }

    override func tearDown() {
        if let savedHeaderStyle = savedHeaderStyle {
            EJKit.shared.style.set(style: savedHeaderStyle, for: EJNativeBlockType.header)
        }
        EJKit.shared.registeredCustomBlocks = savedCustomBlocks
        data = nil
        super.tearDown()
    }

    private func makeRenderedCollectionView() -> (UICollectionView, EJCollectionViewAdapter) {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        let adapter = EJCollectionViewAdapter(collectionView: collectionView)
        adapter.dataSource = self
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        return (collectionView, adapter)
    }

    /// Cells are configured inside `collectionView(_:cellForItemAt:)`, and converting HTML there spins a
    /// nested run loop (`NSHTMLReader` uses WebKit) which re-enters UIKit's update cycle while a cell is
    /// dequeued — UIKit then throws "Expected dequeued view to be returned to the collection view".
    /// So configuring must reuse the string prepared before the dequeue. See issues #31 and #33.
    func testHeaderCellReusesCachedAttributedString() throws {
        data = try EJKit.shared.decode(data: Data(headerJSON.utf8))

        // Poison the cache: whatever the cell displays must have come from it, not from a fresh parse.
        let item = try XCTUnwrap(data?.blocks.first?.data.getItem(atIndex: 0) as? HeaderBlockContentItem)
        item.cachedAttributedString = NSAttributedString(string: "cached")

        let (collectionView, adapter) = makeRenderedCollectionView()
        _ = adapter

        let cell = try XCTUnwrap(collectionView.visibleCells.first)
        let label = try XCTUnwrap(firstView(ofType: UILabel.self, in: cell))

        XCTAssertEqual(label.text, "cached",
                       "Header re-parsed its HTML while configuring instead of reusing the cache")
    }

    /// An assigned string wins for the style in effect when it is assigned, but must NOT freeze the
    /// item: once the style changes, correctness wins and the text is parsed again. Without the
    /// expiry, one assignment through the public setter silently defeats invalidation. See issue #34.
    func testAssignedStringExpiresWhenStyleChanges() throws {
        EJKit.shared.style.set(style: TestHeaderStyle(headerFont: .systemFont(ofSize: 20)),
                               for: EJNativeBlockType.header)
        data = try EJKit.shared.decode(data: Data(headerJSON.utf8))
        let item = try XCTUnwrap(data?.blocks.first?.data.getItem(atIndex: 0) as? HeaderBlockContentItem)
        item.cachedAttributedString = NSAttributedString(string: "assigned")

        let (collectionView, adapter) = makeRenderedCollectionView()
        _ = adapter

        var label = try XCTUnwrap(firstView(ofType: UILabel.self, in: XCTUnwrap(collectionView.visibleCells.first)))
        XCTAssertEqual(label.text, "assigned", "The assigned string must be used under the current style")

        EJKit.shared.style.set(style: TestHeaderStyle(headerFont: .systemFont(ofSize: 32)),
                               for: EJNativeBlockType.header)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        label = try XCTUnwrap(firstView(ofType: UILabel.self, in: XCTUnwrap(collectionView.visibleCells.first)))
        XCTAssertEqual(label.text, "Hello world",
                       "An assigned string froze the item against style changes (issue #34)")
        XCTAssertEqual(try renderedFont(of: label).pointSize, 32)
    }

    /// The cache must be invalidated when the style it was parsed with changes, or headers keep
    /// rendering with the first-parsed font after a theme / Dynamic Type change. See issue #34.
    func testHeaderRerendersWhenStyleFontChanges() throws {
        EJKit.shared.style.set(style: TestHeaderStyle(headerFont: .systemFont(ofSize: 20)),
                               for: EJNativeBlockType.header)
        data = try EJKit.shared.decode(data: Data(headerJSON.utf8))

        let (collectionView, adapter) = makeRenderedCollectionView()
        _ = adapter

        var label = try XCTUnwrap(firstView(ofType: UILabel.self, in: XCTUnwrap(collectionView.visibleCells.first)))
        XCTAssertEqual(try renderedFont(of: label).pointSize, 20)

        EJKit.shared.style.set(style: TestHeaderStyle(headerFont: .systemFont(ofSize: 32)),
                               for: EJNativeBlockType.header)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        label = try XCTUnwrap(firstView(ofType: UILabel.self, in: XCTUnwrap(collectionView.visibleCells.first)))
        XCTAssertEqual(try renderedFont(of: label).pointSize, 32,
                       "Header kept the attributed string parsed with the old style (issue #34)")
    }

    /// A custom block and a native block must not share a reuse pool: the pools hold different cell
    /// classes and dequeuing the wrong one traps on the force-cast. See issue #35.
    func testCustomBlockAndNativeBlockRenderSideBySide() throws {
        EJKit.shared.register(customBlock: EJCustomBlock(type: TestBlockType.testCallout,
                                                         contentClass: BlockContent.Single<TestCalloutContentItem>.self,
                                                         viewClass: TestCalloutContentView.self))
        let json = #"""
        {"time":1,"version":"2.13.2","blocks":[
          {"type":"header","data":{"text":"Hello","level":1}},
          {"type":"testCallout","data":{"text":"hi"}}
        ]}
        """#
        data = try EJKit.shared.decode(data: Data(json.utf8))

        // Would trap here on a shared reuse pool, before any assertion runs.
        let (collectionView, adapter) = makeRenderedCollectionView()
        _ = adapter

        XCTAssertEqual(collectionView.visibleCells.count, 2)
        let texts = collectionView.visibleCells
            .sorted { $0.frame.minY < $1.frame.minY }
            .compactMap { firstView(ofType: UILabel.self, in: $0)?.text }
        XCTAssertEqual(texts, ["Hello", "custom:hi"])
    }

    /// Custom blocks are handled before the native switch, so they must be warmed too: parsing
    /// inside their `configure` would spin a nested run loop with a dequeued cell outstanding.
    /// Sizing cannot be relied on for this — a client delegate overriding sizes bypasses it.
    /// See issues #31 and #33.
    func testCustomBlockItemIsPreparedBeforeDequeueEvenWithoutSizing() throws {
        EJKit.shared.register(customBlock: EJCustomBlock(type: TestBlockType.testCallout,
                                                         contentClass: BlockContent.Single<TestCalloutContentItem>.self,
                                                         viewClass: TestCalloutContentView.self))
        let json = #"""
        {"time":1,"version":"2.13.2","blocks":[{"type":"testCallout","data":{"text":"hi"}}]}
        """#
        data = try EJKit.shared.decode(data: Data(json.utf8))
        let item = try XCTUnwrap(data?.blocks.first?.data.getItem(atIndex: 0) as? TestCalloutContentItem)

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        let adapter = EJCollectionViewAdapter(collectionView: collectionView)
        adapter.dataSource = self
        let sizingDelegate = FixedSizeDelegate()
        adapter.delegate = sizingDelegate
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        _ = adapter

        XCTAssertEqual(collectionView.visibleCells.count, 1)
        XCTAssertGreaterThan(item.prepareCount, 0,
                             "The renderer never prepared the custom block's item, so its configure would parse inside cellForItemAt (issue #33)")
    }

    /// The reuse identifier must distinguish the custom-block cell from the native one even when
    /// both wrap the same content view type. See issue #35.
    func testCustomBlockReuseIdDoesNotCollideWithNativeCells() {
        XCTAssertNotEqual(BaseBlockView<HeaderNativeContentView>.reuseId, HeaderBlockView.reuseId,
                          "Custom-block cells and the native header cell would collide in one reuse pool (issue #35)")
    }

    /// Reconfiguring a reused cell with different insets must replace the old edge constraints, not
    /// stack new ones on top of them. See issue #36.
    func testChangingInsetsDoesNotAccumulateConstraints() throws {
        EJKit.shared.style.set(style: TestHeaderStyle(headerFont: .systemFont(ofSize: 20),
                                                      blockInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)),
                               for: EJNativeBlockType.header)
        data = try EJKit.shared.decode(data: Data(headerJSON.utf8))

        let (collectionView, adapter) = makeRenderedCollectionView()
        _ = adapter

        EJKit.shared.style.set(style: TestHeaderStyle(headerFont: .systemFont(ofSize: 20),
                                                      blockInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)),
                               for: EJNativeBlockType.header)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        let cell = try XCTUnwrap(collectionView.visibleCells.first)
        let contentView = try XCTUnwrap(firstView(ofType: HeaderNativeContentView.self, in: cell))
        let container = try XCTUnwrap(contentView.superview)
        let edgeConstraints = container.constraints.filter { $0.firstItem === contentView || $0.secondItem === contentView }
        XCTAssertEqual(edgeConstraints.count, 4,
                       "Old inset constraints stayed active alongside the new ones (issue #36)")
        XCTAssertEqual(edgeConstraints.first { $0.firstAttribute == .left }?.constant, 30)
    }

    private func renderedFont(of label: UILabel) throws -> UIFont {
        let attributedText = try XCTUnwrap(label.attributedText)
        return try XCTUnwrap(attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont)
    }

    private func firstView<T: UIView>(ofType type: T.Type, in view: UIView) -> T? {
        for subview in view.subviews {
            if let match = subview as? T { return match }
            if let match = firstView(ofType: type, in: subview) { return match }
        }
        return nil
    }
}
