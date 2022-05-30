//
//  DelimiterNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 20/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
open class DelimiterNativeContentView: UIView, ConfigurableBlockView {
    
    // MARK: - UI Properties
    
    public let label = UILabel()
    private var appliedInsets: UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        addSubview(label)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: DelimiterBlockContentItem, style: EJBlockStyle?) {
        label.text = item.text
        
        guard let style = style as? EJDelimiterBlockStyle else { return }
        
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        
        label.textColor = style.color
        label.font = style.font
        label.textAlignment = style.textAlignment
    }
    
    // TODO: Why need `style` argument? It's not used at all
    public static func estimatedSize(for item: DelimiterBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJDelimiterBlockStyle else { return .zero }
        var newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        newBoundingWidth -= style.labelInsets.left + style.labelInsets.right
        var height = item.text.size(using: style.font, boundingWidth: newBoundingWidth).height
        height += style.labelInsets.bottom + style.labelInsets.top
        return CGSize(width: boundingWidth, height: height)
    }
}
