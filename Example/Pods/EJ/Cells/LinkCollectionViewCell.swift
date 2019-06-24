//
//  LinkCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
class LinkCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    let baseView = UIView()
    let linkView = LinkNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(content: LinkBlockContent) {
        guard let item = content.getItem(atIndex: 0) as? LinkBlockContentItem else { return }
        linkView.configure(item: item, formattedLink: content.formattedLink)
    }
    
    func apply(style: EJBlockStyle) {
        linkView.apply(style: style)
    }
    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.linkTool)?.insets ?? .zero
        
        addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(linkView)
        linkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            linkView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            linkView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            linkView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
    }
}
