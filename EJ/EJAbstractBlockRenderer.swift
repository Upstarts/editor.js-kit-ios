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
    associatedtype View: EJBlockStyleApplicable
    var collectionView: UICollectionView { get }
    var startSectionIndex: Int { get }
    func render<T: EJAbstractBlockType>(block: EJAbstractBlock<T>, itemIndex: Int, style: EJBlockStyle?) throws -> View
    func size(forBlock: EJAbstractBlockContent, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize
}

///
public protocol EJBlockStyleApplicable {
    func apply(style: EJBlockStyleApplicable)
}
