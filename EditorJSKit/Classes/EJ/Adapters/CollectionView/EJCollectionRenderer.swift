//
//  EJCollectionRenderer.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 20/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
open class EJCollectionRenderer: EJCollectionBlockRenderer {
    public typealias View = UICollectionViewCell
    
    public var startSectionIndex: Int = .zero
    
    unowned public var collectionView: UICollectionView
    private let kit: EJKit
    
    public init(collectionView: UICollectionView, kit: EJKit = .shared) {
        self.collectionView = collectionView
        self.kit = kit
    }
    
    /**
     */
    public func render(block: EJAbstractBlock, indexPath: IndexPath, style: EJBlockStyle? = nil) throws -> View {
        
        for customBlock in kit.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return try content.render(collectionView: collectionView, block: block, indexPath: indexPath, style: style)
        }
        
        switch block.type {
            
        case EJNativeBlockType.header:
            typealias Cell = CollectionViewBlockCell<HeaderBlockView>
            let reuseId = HeaderBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! HeaderBlockContent
            let item = content.getItem(atIndex: .zero) as! HeaderBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = style ?? kit.style.getStyle(forBlockType: block.type)
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.image:
            typealias Cell = CollectionViewBlockCell<ImageBlockView>
            let reuseId = ImageBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! ImageBlockContent
            let item = content.getItem(atIndex: indexPath.item) as! ImageBlockContentItem
            if item.file.imageData == nil {
                item.file.callback = { [weak self] in
                    self?.collectionView.reloadItems(at: [indexPath])
                }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = style ?? kit.style.getStyle(forBlockType: block.type)
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.list:
            typealias Cell = CollectionViewBlockCell<ListItemBlockView>
            let reuseId = ListItemBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! ListBlockContent
            let item = content.getItem(atIndex: indexPath.item) as! ListBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = style ?? kit.style.getStyle(forBlockType: block.type)
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.linkTool:
            typealias Cell = CollectionViewBlockCell<LinkBlockView>
            let reuseId = LinkBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! LinkBlockContent
            let item = content.getItem(atIndex: .zero) as! LinkBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = style ?? kit.style.getStyle(forBlockType: block.type)
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.delimiter:
            typealias Cell = CollectionViewBlockCell<DelimiterBlockView>
            let reuseId = DelimiterBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! DelimiterBlockContent
            let item = content.getItem(atIndex: .zero) as! DelimiterBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = style ?? kit.style.getStyle(forBlockType: block.type)
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.paragraph:
            typealias Cell = CollectionViewBlockCell<ParagraphBlockView>
            let reuseId = ParagraphBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! ParagraphBlockContent
            let item = content.getItem(atIndex: .zero) as! ParagraphBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = style ?? kit.style.getStyle(forBlockType: block.type)
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.raw:
            typealias Cell = CollectionViewBlockCell<RawHtmlBlockView>
            let reuseId = RawHtmlBlockView.reuseId
            collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseId)
            let content = block.data as! RawHtmlBlockContent
            let item = content.getItem(atIndex: .zero) as! RawHtmlBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! Cell
            let style = kit.style.getStyle(forBlockType: EJNativeBlockType.raw)
            cell.configure(withItem: item, style: style)
            return cell
            
        default: throw EJError.missmatch
        }
        
    }
    
    public func size(forBlock block: EJAbstractBlock, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize {
        
        for customBlock in kit.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return try content.size(forBlock: block, itemIndex: itemIndex, style: style, superviewSize: superviewSize)
        }
        
        switch block.type {
        case EJNativeBlockType.header:
            return HeaderNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! HeaderBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.image:
            return ImageNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! ImageBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.list:
            return ListItemNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! ListBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.linkTool:
            return LinkNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! LinkBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.delimiter:
            return DelimiterNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! DelimiterBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.paragraph:
            return ParagraphNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! ParagraphBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.raw:
            return RawHtmlNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! RawHtmlBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        default: return kit.style.defaultItemSize
        }
    }
    
    public func insets(forBlock block: EJAbstractBlock) -> UIEdgeInsets {
        for customBlock in kit.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return content.insets(forBlock: block)
        }
        
        var insets = kit.style.defaultSectionInsets
        switch block.type {
        case EJNativeBlockType.header:
            guard
                let headerItem = (block.data as? HeaderBlockContent)?.getItem(atIndex: 0) as? HeaderBlockContentItem,
                let headerStyle = kit.style.getStyle(forBlockType: block.type) as? EJHeaderBlockStyle
            else { return insets }
            insets.top += headerStyle.topInset(forHeaderLevel: headerItem.level)
            insets.bottom += headerStyle.bottomInset(forHeaderLevel: headerItem.level)
            return insets
        default:
            break
        }
        return insets
    }
    
    public func spacing(forBlock block: EJAbstractBlock) -> CGFloat {
        for customBlock in kit.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return content.spacing(forBlock: block)
        }
        
        if let style = kit.style.getStyle(forBlockType: block.type) {
            return style.lineSpacing
        }
        return kit.style.defaultItemsLineSpacing
    }
}
