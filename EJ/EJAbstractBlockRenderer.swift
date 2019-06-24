//
//  EJBlockRenderer.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

///
public protocol EJAbstractBlockRenderer {
    associatedtype View
    var collectionView: UICollectionView { get }
    var startSectionIndex: Int { get }
    func render(block: EJAbstractBlock, itemIndexPath: IndexPath, style: EJBlockStyle?) throws -> View
    func size(forBlock: EJAbstractBlock, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize
}

///
public protocol EJBlockStyleApplicable {
    func apply(style: EJBlockStyle)
}

///
open class EJCollectionRenderer: EJAbstractBlockRenderer {
    
    public var startSectionIndex: Int = 0
    
    unowned public var collectionView: UICollectionView
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
    }
    
    public func render(block: EJAbstractBlock, itemIndexPath: IndexPath, style: EJBlockStyle? = nil) throws -> UICollectionViewCell & EJBlockStyleApplicable {
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.description())
        guard let content = block.data as? HeaderBlockContent else { throw EJError.missmatch }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.description(), for: itemIndexPath) as? HeaderCollectionViewCell else { throw EJError.missmatch }
        cell.configure(content: content)
        if let style = style ?? EJKit.shared.style?.style(forBlockType: block.type) {
            cell.apply(style: style)
        }
        
        cell.apply(style: HeaderBlockNativeStyle())
        return cell
    }
    
    public func size(forBlock: EJAbstractBlock, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize {
        
        switch forBlock.type {
        case EJNativeBlockType.header:
            print( HeaderView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! HeaderBlockContentItem, style: style, boundingWidth: superviewSize.width) )
            return HeaderView.estimatedSize(for: forBlock.data.getItem(atIndex: itemIndex) as! HeaderBlockContentItem, style: style, boundingWidth: superviewSize.width)
        default: return .zero
        }
    }
}

///
enum EJError: Error {
    case missmatch
}
