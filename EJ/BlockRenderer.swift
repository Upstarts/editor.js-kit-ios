//
//  BlockRenderer.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

///
public protocol EJBlockRendererProtocol {
    
    var collectionView: UICollectionView { get }
    var startSectionIndex: Int { get }
    func render(block: T)
}
