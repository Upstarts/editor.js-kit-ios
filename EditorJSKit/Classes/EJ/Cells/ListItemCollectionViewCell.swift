//
//  ListItemCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
class ListItemCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    let baseView = UIView()
    let listItemView = ListItemNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(itemContent: ListBlockContentItem, style: ListBlockStyle) {
        listItemView.configure(itemContent: itemContent, style: style)
    }
    
    func apply(style: EJBlockStyle) {
        listItemView.apply(style: style)
    }
    
    
    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list)?.insets ?? .zero
        
        addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(listItemView)
        listItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listItemView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            listItemView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            listItemView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            listItemView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
    }
    
    
}
