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
    
    public func render(block: EJAbstractBlock, itemIndexPath: IndexPath, style: EJBlockStyle? = nil) throws -> View {
        
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == block.type.rawValue else { continue }
            guard let content = block.data as? EJCollectionRendererAdaptableContent else { continue }
            return try! content.render(collectionView: collectionView, block: block, itemIndexPath: itemIndexPath, style: nil)
        }
        
        switch block.type {
            
        case EJNativeBlockType.header:
            collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.description())
            let content = block.data as! HeaderBlockContent
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.description(), for: itemIndexPath) as! HeaderCollectionViewCell
            cell.configure(content: content)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.image:
            collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.description())
            let content = block.data as! ImageBlockContent
            let item = content.getItem(atIndex: itemIndexPath.item) as! ImageBlockContentItem
            if item.file.imageData == nil {
                item.file.callback = { self.collectionView.reloadItems(at: [itemIndexPath]) }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.description(), for: itemIndexPath) as! ImageCollectionViewCell
            cell.configure(content: content)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.list:
            collectionView.register(ListItemCollectionViewCell.self, forCellWithReuseIdentifier: ListItemCollectionViewCell.description())
            let content = block.data as! ListBlockContent
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListItemCollectionViewCell.description(), for: itemIndexPath) as! ListItemCollectionViewCell
            cell.configure(itemContent: content.getItem(atIndex: itemIndexPath.item) as! ListBlockContentItem, style: content.style)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.linkTool:
            collectionView.register(LinkCollectionViewCell.self, forCellWithReuseIdentifier: LinkCollectionViewCell.description())
            let content = block.data as! LinkBlockContent
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCollectionViewCell.description(), for: itemIndexPath) as! LinkCollectionViewCell
            cell.configure(content: content)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.delimiter:
            collectionView.register(DelimiterCollectionViewCell.self, forCellWithReuseIdentifier: DelimiterCollectionViewCell.description())
            let content = block.data as! DelimiterBlockContent
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DelimiterCollectionViewCell.description(), for: itemIndexPath) as! DelimiterCollectionViewCell
            cell.configure(content: content)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.paragraph:
            collectionView.register(ParagraphCollectionViewCell.self, forCellWithReuseIdentifier: ParagraphCollectionViewCell.description())
            let content = block.data as! ParagraphBlockContent
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParagraphCollectionViewCell.description(), for: itemIndexPath) as! ParagraphCollectionViewCell
            cell.configure(content: content)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: block.type)!)
            return cell
            
        case EJNativeBlockType.raw:
            collectionView.register(RawHtmlCollectionViewCell.self, forCellWithReuseIdentifier: RawHtmlCollectionViewCell.description())
            let content = block.data as! RawHtmlBlockContent
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RawHtmlCollectionViewCell.description(), for: itemIndexPath) as! RawHtmlCollectionViewCell
            cell.configure(content: content)
            cell.apply(style: style ?? EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.raw)!)
            return cell
            
        default: throw EJError.missmatch
        }
        
    }
    
    public func size(forBlock: EJAbstractBlock, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize {
        
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == forBlock.type.rawValue else { continue }
            guard let content = forBlock.data as? EJCollectionRendererAdaptableContent else { continue }
            return try! content.size(forBlock: forBlock, itemIndex: itemIndex, style: nil, superviewSize: superviewSize)
        }
        
        switch forBlock.type {
        case EJNativeBlockType.header:
            return HeaderNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! HeaderBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.image:
            return ImageNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! ImageBlockContentItem, style: nil, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.list:
            return ListItemNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! ListBlockContentItem, style: nil, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.linkTool:
            return LinkNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! LinkBlockContentItem, style: nil, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.delimiter:
            return DelimiterNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! DelimiterBlockContentItem, style: nil, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.paragraph:
            return ParagraphNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! ParagraphBlockContentItem, style: nil, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.raw:
            return RawHtmlNativeView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! RawHtmlBlockContentItem, style: nil, boundingWidth: superviewSize.width)
            
        default: return CGSize(width: 200, height: 50)
        }
    }
    
    public func insets(forBlock: EJAbstractBlock) -> UIEdgeInsets {
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == forBlock.type.rawValue else { continue }
            guard let content = forBlock.data as? EJCollectionRendererAdaptableContent else { continue }
            return content.insets(forBlock: forBlock)
        }
        
        switch forBlock.type {
        case EJNativeBlockType.header: return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        case EJNativeBlockType.delimiter: return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        default: return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        }
    }
    
    public func spacing(forBlock: EJAbstractBlock) -> CGFloat {
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard customBlock.type.rawValue == forBlock.type.rawValue else { continue }
            guard let content = forBlock.data as? EJCollectionRendererAdaptableContent else { continue }
            return content.spacing(forBlock: forBlock)
        }
        
        switch forBlock.type {
        default: return 4
        }
    }
    
}
