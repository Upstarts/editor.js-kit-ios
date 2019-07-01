//
//  DelimiterStarsCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
class DelimiterCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    
    private let baseView = UIView()
    private let delimiterView = DelimiterNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.delimiter)?.insets ?? .zero
        addSubview(baseView)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(delimiterView)
        delimiterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            delimiterView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            delimiterView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            delimiterView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            delimiterView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
        
    }
    
    public func configure(content: DelimiterBlockContent) {
        guard let item = content.getItem(atIndex: 0) as? DelimiterBlockContentItem else { return }
        delimiterView.configure(item: item)
    }
    
    func apply(style: EJBlockStyle) {
        delimiterView.apply(style: style)
    }
    
}
