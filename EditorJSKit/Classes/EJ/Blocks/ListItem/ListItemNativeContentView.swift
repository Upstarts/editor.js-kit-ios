//
//  ListItemNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
open class ListItemNativeContentView: UIView, ConfigurableBlockView {
    public let textView = UITextViewFixed()
    private let imageView = UIImageView()
    
    private var imageSize = CGSize.zero
    
    private var imageViewLeftConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var leftTextViewConstraint: NSLayoutConstraint?
    private var rightTextViewConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageSize.width)
        self.heightConstraint = heightConstraint
        self.widthConstraint = widthConstraint
        
        let imageViewLeftConstraint = imageView.leftAnchor.constraint(equalTo: leftAnchor)
        self.imageViewLeftConstraint = imageViewLeftConstraint
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageViewLeftConstraint,
            heightConstraint,
            widthConstraint
        ])
        
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.alwaysBounceVertical = false
        textView.isScrollEnabled = false
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftTextViewConstraint = textView.leftAnchor.constraint(equalTo: imageView.rightAnchor)
        self.leftTextViewConstraint = leftTextViewConstraint
        let rightTextViewConstraint = textView.rightAnchor.constraint(equalTo: rightAnchor)
        self.rightTextViewConstraint = rightTextViewConstraint
        
        NSLayoutConstraint.activate([
            leftTextViewConstraint,
            rightTextViewConstraint,
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private static func makeAttributedString(item: ListBlockContentItem, style: EJListBlockStyle?) -> NSAttributedString {
        let itemStyle = item.style
        let prefix = itemStyle == .unordered ? "" : "\(item.index).\t"
        let attributedString = NSMutableAttributedString(string: prefix)
        if let style = style {
            attributedString.addAttributes([.font: style.font], range: .init(location: .zero, length: attributedString.string.count)) 
        }
        
        if let cachedString = item.cachedAttributedString {
            attributedString.append(cachedString)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        let tabSpace = style?.tabulationSpace ?? Constants.defaultTabSpace
        let tabStop = NSTextTab(textAlignment: .left, location: tabSpace, options: [:])
        paragraphStyle.defaultTabInterval = tabSpace
        paragraphStyle.tabStops = [tabStop]
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.string.count))
        return attributedString
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: ListBlockContentItem, style: EJBlockStyle?) {
        guard let style = style as? EJListBlockStyle else { return }
        
        // 1. Apply UI
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        textView.textColor = style.color
        imageView.image = style.imageForUnorderedList
        
        imageViewLeftConstraint?.constant = style.leftInset
        leftTextViewConstraint?.constant = style.insetBetweenImageAndText
        rightTextViewConstraint?.constant = style.rightInset
        
        // 2. Apply content
        item.prepareCachedAttributedString(withStyle: style)
        let attributedString = Self.makeAttributedString(item: item, style: style)
        textView.attributedText = attributedString

        imageSize = item.style == .unordered ? style.sizeForUnorderedImage : .zero
        widthConstraint?.constant = imageSize.width
        heightConstraint?.constant = imageSize.height
        leftTextViewConstraint?.constant = item.style == .unordered ? style.insetBetweenImageAndText : .zero
    }
    
    public static func estimatedSize(for item: ListBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJListBlockStyle else { return .zero }
        item.prepareCachedAttributedString(withStyle: style)
        
        var textBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        textBoundingWidth -= (style.leftInset + style.rightInset)
        
        if item.style == .unordered {
            let imageWidth = style.sizeForUnorderedImage.width
            textBoundingWidth -= (imageWidth + style.insetBetweenImageAndText)
        }
        
        let string = makeAttributedString(item: item, style: style)
        var height = string.textViewHeight(boundingWidth: textBoundingWidth)
        
        if item.style == .unordered && height < style.sizeForUnorderedImage.height {
            height = style.sizeForUnorderedImage.height
        }
        
        return CGSize(width: boundingWidth, height: height)
    }
}

///
extension ListItemNativeContentView {
    struct Constants {
        static let defaultTabSpace: CGFloat = 10
    }
}

