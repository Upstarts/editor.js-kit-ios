import XCTest
import UIKit
import EditorJSKit

class Tests: XCTestCase, EJCollectionDataSource {

    var data: EJBlocksList?

    /// Cells are configured inside `collectionView(_:cellForItemAt:)`, and converting HTML there spins a
    /// nested run loop (`NSHTMLReader` uses WebKit) which re-enters UIKit's update cycle while a cell is
    /// dequeued — UIKit then throws "Expected dequeued view to be returned to the collection view".
    /// So configuring must reuse the string cached during sizing rather than re-parsing. See issue #31.
    func testHeaderCellReusesCachedAttributedString() throws {
        let json = #"""
        {"time":1,"version":"2.13.2","blocks":[{"type":"header","data":{"text":"<b>Hello</b> world","level":1}}]}
        """#
        data = try EJKit.shared.decode(data: Data(json.utf8))

        // Poison the cache: whatever the cell displays must have come from it, not from a fresh parse.
        let item = try XCTUnwrap(data?.blocks.first?.data.getItem(atIndex: 0) as? HeaderBlockContentItem)
        item.cachedAttributedString = NSAttributedString(string: "cached")

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        let adapter = EJCollectionViewAdapter(collectionView: collectionView)
        adapter.dataSource = self
        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        let cell = try XCTUnwrap(collectionView.visibleCells.first)
        let label = try XCTUnwrap(firstLabel(in: cell))

        XCTAssertEqual(label.text, "cached",
                       "Header re-parsed its HTML while configuring instead of reusing the cache")
    }

    private func firstLabel(in view: UIView) -> UILabel? {
        for subview in view.subviews {
            if let label = subview as? UILabel { return label }
            if let label = firstLabel(in: subview) { return label }
        }
        return nil
    }
}
