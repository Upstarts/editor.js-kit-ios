//
//  EJCollectionViewAdapter.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 28.05.2022.
//

import UIKit

///
public final class EJCollectionViewAdapter: NSObject {
    
    ///
    unowned let collectionView: UICollectionView
    private let kit: EJKit
    public var dataSource: EJCollectionDataSource?
    
    /// Custom delegate if you witsh to override sizes / insets
    public var delegate: UICollectionViewDelegateFlowLayout? {
        didSet {
            collectionView.delegate = delegate
        }
    }
    
    // MARK: Inner tools
    
    private lazy var renderer = EJCollectionRenderer(collectionView: collectionView)
    
    /**
     */
    public init(collectionView: UICollectionView, kit: EJKit = .shared) {
        self.collectionView = collectionView
        self.kit = kit
        super.init()
        collectionView.dataSource = self
        delegate = self
        collectionView.delegate = delegate
    }
}

///
extension EJCollectionViewAdapter: UICollectionViewDataSource {
    
    /**
     */
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.data?.blocks.count ?? .zero
    }

    /**
     */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.data?.blocks[section].data.numberOfItems ?? .zero
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = dataSource?.data else {
            return UICollectionViewCell()
        }
        do {
            let block = data.blocks[indexPath.section]
            let style = kit.style.getStyle(forBlockType: block.type)
            return try renderer.render(block: block, indexPath: indexPath, style: style)
        }
        catch {
            return UICollectionViewCell()
        }
    }
}

///
extension EJCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let data = dataSource?.data,
              (.zero ..< data.blocks.count).contains(indexPath.section)
        else { return .zero }
        do {
            let block = data.blocks[indexPath.section]
            let style = kit.style.getStyle(forBlockType: block.type)
            return try renderer.size(forBlock: block,
                                     itemIndex: indexPath.item,
                                     style: style,
                                     superviewSize: collectionView.frame.size)
        } catch {
            return .zero
        }
    }

    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let data = dataSource?.data,
              (.zero ..< data.blocks.count).contains(section)
        else { return .zero }
        return renderer.spacing(forBlock: data.blocks[section])
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let data = dataSource?.data,
              (.zero ..< data.blocks.count).contains(section)
        else { return .zero }
        return renderer.insets(forBlock: data.blocks[section])
    }
}
