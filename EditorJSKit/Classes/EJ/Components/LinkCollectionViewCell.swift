//
//  LinkCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class LinkCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    private let baseView = UIView()
    private let linkView = LinkNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(item: LinkBlockContentItem) {
        linkView.configure(item: item)
    }
    
    public func apply(style: EJBlockStyle) {
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
