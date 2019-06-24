//
//  HeaderNativeView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
class HeaderNativeView: UIView, EJBlockStyleApplicable {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    public func configure(item: HeaderBlockContentItem) {
        label.attributedText = item.attributedString
    }
    
    public func apply(style: EJBlockStyle) {
        guard let style = style as? EJHeaderBlockStyle else { return }
        label.textAlignment = style.alignment
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    static func estimatedSize(for item: HeaderBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let attributed = item.attributedString else { return .zero }
        let height = attributed.height(withConstrainedWidth: boundingWidth)
        return CGSize(width: boundingWidth, height: height)
    }
}

