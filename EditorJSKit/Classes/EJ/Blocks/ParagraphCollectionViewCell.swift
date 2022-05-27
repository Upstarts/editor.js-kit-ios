//
//  ParagraphCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

open class ParagraphCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    
    private let baseView = UIView()
    private let paragraphView = ParagraphNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.paragraph)?.insets ?? .zero
        addSubview(baseView)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(paragraphView)
        paragraphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paragraphView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            paragraphView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            paragraphView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            paragraphView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
        
    }
    
    public func configureCell(item: ParagraphBlockContentItem) {
        paragraphView.configure(item: item)
    }
    
    
    public func apply(style: EJBlockStyle) {
        paragraphView.apply(style: style)
    }
    
}
