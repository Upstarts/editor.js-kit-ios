//
//  HeaderNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class HeaderNativeContentView: UIView, ConfigurableBlockView {
    
    public let label = UILabel()
    
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
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: HeaderBlockContentItem, style: EJBlockStyle?) {
        guard let style = style as? EJHeaderBlockStyle else {
            label.text = item.text
            return
        }
        let attributedString = item.text.convertHTML(font: style.font(forHeaderLevel: item.level), forceFontFace: true)
        if item.cachedAttributedString == nil {
            item.cachedAttributedString = attributedString
        }
        label.attributedText = attributedString
        
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        label.textAlignment = style.alignment
    }
    
    public static func estimatedSize(for item: HeaderBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJHeaderBlockStyle else { return .zero }
        let attributedString = item.cachedAttributedString ?? item.text.convertHTML(font: style.font(forHeaderLevel: item.level), forceFontFace: true)
        if item.cachedAttributedString == nil {
            item.cachedAttributedString = attributedString
        }
        let newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        let height = attributedString?.height(withConstrainedWidth: newBoundingWidth) ?? .zero
        return CGSize(width: boundingWidth, height: height)
    }
}

