//
//  CollectionViewBlockCell.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 27.05.2022.
//

import UIKit

///
public class CollectionViewBlockCell<EmbeddedView: UIView>: UICollectionViewCell, ConfigurableBlockView where EmbeddedView: EJBlockView {
    
    public typealias BlockContentItem = EmbeddedView.BlockContentItem
    
    private let embeddedView = EmbeddedView()

    override public var reuseIdentifier: String? {
        EmbeddedView.reuseId
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(embeddedView)
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            embeddedView.leftAnchor.constraint(equalTo: leftAnchor),
            embeddedView.rightAnchor.constraint(equalTo: rightAnchor),
            embeddedView.topAnchor.constraint(equalTo: topAnchor),
            embeddedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(withItem item: BlockContentItem, style: EJBlockStyle?) {
        embeddedView.configure(withItem: item, style: style)
    }

    /**
     */
    public static func estimatedSize(for item: BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        EmbeddedView.estimatedSize(for: item, style: style, boundingWidth: boundingWidth)
    }
}
