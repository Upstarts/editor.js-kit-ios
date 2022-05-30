//
//  EJCustomBlock.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 30.05.2022.
//

///
public protocol EJAbstractCustomBlock {
    var type: EJAbstractBlockType { get }
    var abstractContentClass: EJAbstractBlockContent.Type { get }
}

///
public protocol EJCustomBlockProtocol: EJAbstractCustomBlock {
    associatedtype View: ConfigurableBlockView
    associatedtype Content: EJAbstractBlockContent
    
    var contentClass: Content.Type { get }
    var viewClass: View.Type { get }
}

///
public struct EJCustomBlock<V: EJBlockView, C: EJAbstractBlockContent>: EJCustomBlockProtocol, EJCustomBlockCollectionAdaptable where V: UIView {

    public typealias View = V
    public typealias Content = C
    
    static public var reuseId: String { V.reuseId }
    
    public var type: EJAbstractBlockType
    public var contentClass: Content.Type
    public var viewClass: View.Type
    public var abstractContentClass: EJAbstractBlockContent.Type { Content.self }
    
    /**
     */
    public init(type: EJAbstractBlockType, contentClass: Content.Type, viewClass: View.Type) {
        self.type = type
        self.contentClass = contentClass
        self.viewClass = viewClass
    }
    
    // MARK: - EJCustomBlockCollectionAdaptable
    
    /**
     */
    public func prepareCell(forCollectionView collectionView: UICollectionView,
                            contentItem: EJAbstractBlockContentItem,
                            indexPath: IndexPath,
                            style: EJBlockStyle?) -> UICollectionViewCell? {
        guard let item = contentItem as? V.BlockContentItem else { return nil }
        typealias Cell = CollectionViewBlockCell<BaseBlockView<View>>
        let reuseId = HeaderBlockView.reuseId
        collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
        cell.configure(withItem: item, style: style)
        return cell
    }
    
    /**
     */
    public func estimatedSize(forBlock block: EJAbstractBlock,
                              itemIndex: Int,
                              style: EJBlockStyle?,
                              superviewSize: CGSize) -> CGSize? {
        guard let contentItem = block.data.getItem(atIndex: itemIndex) as? V.BlockContentItem else { return nil }
        return View.estimatedSize(for: contentItem, style: style, boundingWidth: superviewSize.width)
    }
}
