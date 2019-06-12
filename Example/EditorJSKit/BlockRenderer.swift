//
//  BlockRenderer.swift
//  EditorJSKit_Example
//
//  Created by Иван Глушко on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

///
protocol BlockRendererProtocol {
    var collectionView: UICollectionView { get }
    var startSectionIndex: Int { get }
    func render(block: AbstractBlock)
}
