//
//  HeaderNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class HeaderNativeContentView: UIView, EJBlockStyleApplicable, ConfigurableBlockView {
    
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
    
    public func configure(withItem item: HeaderBlockContentItem) {
        label.attributedText = item.attributedString
    }
    
    public static func estimatedSize(for item: HeaderBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let attributed = item.attributedString, let style = style ?? EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.header)  else { return .zero }
        let newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        let height = attributed.height(withConstrainedWidth: newBoundingWidth)
        return CGSize(width: boundingWidth, height: height)
    }
    
    // MARK: - EJBlockStyleApplicable conformance
    
    public func apply(style: EJBlockStyle) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        
        guard let style = style as? EJHeaderBlockStyle else { return }
        label.textAlignment = style.alignment
    }
}

