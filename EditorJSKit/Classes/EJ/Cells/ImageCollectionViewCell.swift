//
//  ImageCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

public class ImageCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    public let baseView = UIView()
    public let imageView = ImageNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(item: ImageBlockContentItem) {
        imageView.configure(item: item)
    }
    
    public func apply(style: EJBlockStyle) {
        imageView.apply(style: style)
    }
    

    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image)?.insets ?? .zero
        
        addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            imageView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            imageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            imageView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
    }
}
