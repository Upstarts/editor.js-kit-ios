import XCTest
import UIKit
import EditorJSKit

/// Lets a native library content view be used as a custom block view — the collision scenario of issue #35.
extension HeaderNativeContentView: EJBlockView {}

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

class Tests: XCTestCase, EJCollectionDataSource {

    var data: EJBlocksList?

    private let headerJSON = #"""
    {"time":1,"version":"2.13.2","blocks":[{"type":"header","data":{"text":"<b>Hello</b> world","level":1}}]}
    """#

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
    /// So configuring must reuse the string cached during sizing rather than re-parsing. See issue #31.
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

    /// A custom block wrapping a library content view (or any same-named view from another module)
    /// must not share a reuse pool with the native block's cell — the pools hold different cell
    /// classes and the dequeue force-cast traps. See issue #35.
    func testCustomBlockReuseIdDoesNotCollideWithNativeCells() {
        XCTAssertNotEqual(BaseBlockView<HeaderNativeContentView>.reuseId, HeaderBlockView.reuseId,
                          "Custom-block cells and the native header cell would collide in one reuse pool (issue #35)")
        XCTAssertEqual(EJCustomBlock<HeaderNativeContentView, HeaderBlockContent>.reuseId,
                       BaseBlockView<HeaderNativeContentView>.reuseId,
                       "The public reuseId must match the identifier prepareCell registers under (issue #35)")
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
