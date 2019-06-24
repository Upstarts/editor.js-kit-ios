//
//  RawHtmlCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

class RawHtmlCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    
    private let baseView = UIView()
    private let rawHtmlView = RawHtmlNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.raw)?.insets ?? .zero
        addSubview(baseView)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(rawHtmlView)
        rawHtmlView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rawHtmlView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            rawHtmlView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            rawHtmlView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            rawHtmlView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
        
    }
    
    func configure(content: RawHtmlBlockContent) {
        guard let item = content.getItem(atIndex: 0) as? RawHtmlBlockContentItem else { return }
        rawHtmlView.configure(withModel: item)
    }
    
    
    func apply(style: EJBlockStyle) {
        rawHtmlView.apply(style: style)
    }
    
}
