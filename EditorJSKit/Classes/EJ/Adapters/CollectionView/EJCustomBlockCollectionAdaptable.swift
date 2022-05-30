//
//  EJCustomBlockCollectionAdaptable.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 30.05.2022.
//

import UIKit

///
protocol EJCustomBlockCollectionAdaptable: EJAbstractCustomBlock, ReusableBlockView {
    func prepareCell(forCollectionView collectionView: UICollectionView,
                     contentItem: EJAbstractBlockContentItem,
                     indexPath: IndexPath,
                     style: EJBlockStyle?) -> UICollectionViewCell?
    func estimatedSize(forBlock block: EJAbstractBlock,
                       itemIndex: Int,
                       style: EJBlockStyle?,
                       superviewSize: CGSize) -> CGSize?
}
