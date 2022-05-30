//
//  RawHtmlNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
open class RawHtmlNativeContentView: UIView, ConfigurableBlockView {
    public let textView = UITextViewFixed()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews() {
        addSubview(textView)
        
        textView.isEditable = false
        textView.textContainerInset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: RawHtmlBlockContentItem, style: EJBlockStyle?) {
        guard let style = style as? EJRawHtmlBlockStyle else { return }
        
        let attributedString = item.cachedAttributedString ?? item.html.convertHTML(font: style.font)
        if item.cachedAttributedString == nil {
            item.cachedAttributedString = attributedString
        }
        textView.attributedText = attributedString
        
        textView.linkTextAttributes = style.linkTextAttributes
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    public static func estimatedSize(for item: RawHtmlBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJRawHtmlBlockStyle else { return .zero }
        let attributedString = item.cachedAttributedString ?? item.html.convertHTML(font: style.font)
        if item.cachedAttributedString == nil {
            item.cachedAttributedString = attributedString
        }
        
        guard let attributedString = attributedString else { return .zero }
        let newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        let height = attributedString.height(withConstrainedWidth: newBoundingWidth )
        return CGSize(width: boundingWidth, height: height)
    }
    
    // MARK: - EJBlockStyleApplicable conformance
    
    public func apply(style: EJBlockStyle) {
        
    }
}
