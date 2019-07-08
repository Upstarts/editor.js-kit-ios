//
//  ParagraphNativeView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 20/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
open class ParagraphNativeView: UIView, EJBlockStyleApplicable, EJConfigurableView  {
    public let textView = UITextView()
    
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
    
    
    public func configure(item: ParagraphBlockContentItem) {
        textView.attributedText = item.attributedString
    }
    
    public func apply(style: EJBlockStyle) {
        guard let style = style as? ParagraphNativeStyle else { return }
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    
    public static func estimatedSize(for item: ParagraphBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let attributed = item.attributedString, let style = style ?? EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.paragraph) else { return .zero }
        let newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        let height = attributed.textViewHeight(boundingWidth: newBoundingWidth)
        return CGSize(width: boundingWidth, height: height)
    }
}
