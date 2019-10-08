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
    public typealias View = UICollectionViewCell & EJBlockStyleApplicable
    
    
    public var startSectionIndex: Int = 0
    
    unowned public var collectionView: UICollectionView
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func render(block: EJAbstractBlock, indexPath: IndexPath, style: EJBlockStyle? = nil) throws -> View {
        
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return try! content.render(collectionView: collectionView, block: block, indexPath: indexPath, style: nil)
        }
        
        switch block.type {
            
        case EJNativeBlockType.header:
            collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.description())
            let content = block.data as! HeaderBlockContent
            let item = content.getItem(atIndex: 0) as! HeaderBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.description(), for: indexPath) as! HeaderCollectionViewCell
            cell.configureCell(item: item)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.image:
            collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.description())
            let content = block.data as! ImageBlockContent
            let item = content.getItem(atIndex: indexPath.item) as! ImageBlockContentItem
            if item.file.imageData == nil {
                item.file.callback = { self.collectionView.reloadItems(at: [indexPath]) }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.description(), for: indexPath) as! ImageCollectionViewCell
            cell.configureCell(item: item)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.list:
            collectionView.register(ListItemCollectionViewCell.self, forCellWithReuseIdentifier: ListItemCollectionViewCell.description())
            let content = block.data as! ListBlockContent
            let item = content.getItem(atIndex: indexPath.item) as! ListBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListItemCollectionViewCell.description(), for: indexPath) as! ListItemCollectionViewCell
            cell.configureCell(item: item, style: content.style)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.linkTool:
            collectionView.register(LinkCollectionViewCell.self, forCellWithReuseIdentifier: LinkCollectionViewCell.description())
            let content = block.data as! LinkBlockContent
            let item = content.getItem(atIndex: 0) as! LinkBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCollectionViewCell.description(), for: indexPath) as! LinkCollectionViewCell
            cell.configureCell(item: item)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.delimiter:
            collectionView.register(DelimiterCollectionViewCell.self, forCellWithReuseIdentifier: DelimiterCollectionViewCell.description())
            let content = block.data as! DelimiterBlockContent
            let item = content.getItem(atIndex: 0) as! DelimiterBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DelimiterCollectionViewCell.description(), for: indexPath) as! DelimiterCollectionViewCell
            cell.configureCell(item: item)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.paragraph:
            collectionView.register(ParagraphCollectionViewCell.self, forCellWithReuseIdentifier: ParagraphCollectionViewCell.description())
            let content = block.data as! ParagraphBlockContent
            let item = content.getItem(atIndex: 0) as! ParagraphBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParagraphCollectionViewCell.description(), for: indexPath) as! ParagraphCollectionViewCell
            cell.configureCell(item: item)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.raw:
            collectionView.register(RawHtmlCollectionViewCell.self, forCellWithReuseIdentifier: RawHtmlCollectionViewCell.description())
            let content = block.data as! RawHtmlBlockContent
            let item = content.getItem(atIndex: 0) as! RawHtmlBlockContentItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RawHtmlCollectionViewCell.description(), for: indexPath) as! RawHtmlCollectionViewCell
            cell.configureCell(item: item)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.raw)!)
            return cell
            
        default: throw EJError.missmatch
        }
        
    }
    
    public func size(forBlock: EJAbstractBlock, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize {
        
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == forBlock.type.rawValue else { continue }
            guard let content = forBlock.data as? EJCollectionRendererAdaptableContent else { continue }
            return try content.size(forBlock: forBlock, itemIndex: itemIndex, style: nil, superviewSize: superviewSize)
        }
        
        switch forBlock.type {
        case EJNativeBlockType.header:
            return HeaderNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! HeaderBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.image:
            return ImageNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! ImageBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.list:
            guard let data = forBlock.data as? ListBlockContent else {
                throw EJError.missmatch
            }
            return ListItemNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! ListBlockContentItem, itemsStyle: data.style, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.linkTool:
            return LinkNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! LinkBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.delimiter:
            return DelimiterNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! DelimiterBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.paragraph:
            return ParagraphNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! ParagraphBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.raw:
            return RawHtmlNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! RawHtmlBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        default: return EJKit.shared.style.defaultItemSize
        }
    }
    
    public func insets(forBlock block: EJAbstractBlock) -> UIEdgeInsets {
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return content.insets(forBlock: block)
        }
        
        var insets = EJKit.shared.style.defaultSectionInsets
        switch block.type {
        case EJNativeBlockType.header:
            guard
                let headerItem = (block.data as? HeaderBlockContent)?.getItem(atIndex: 0) as? HeaderBlockContentItem,
                let headerStyle = EJKit.shared.style.getStyle(forBlockType: block.type) as? EJHeaderBlockStyle
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
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return content.spacing(forBlock: block)
        }
        
        if let style = EJKit.shared.style.getStyle(forBlockType: block.type) {
            return style.lineSpacing
        }
        return EJKit.shared.style.defaultItemsLineSpacing
    }
    
}
