//
//  ListItemView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
open class ListItemNativeView: UIView, EJBlockStyleApplicable {
    public let textView = UITextViewFixed()
    private let imageView = UIImageView()
    
    private var imageSize = CGSize.zero
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var leftTextViewConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageSize.width)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.leftInset ?? 0),
            heightConstraint!,
            widthConstraint!
        ])
        
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.alwaysBounceVertical = false
        textView.isScrollEnabled = false
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        leftTextViewConstraint = textView.leftAnchor.constraint(equalTo: imageView.rightAnchor,
                                                                constant: style?.insetBetweenImageAndText ?? .zero)
        NSLayoutConstraint.activate([
            leftTextViewConstraint!,
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.rightInset ?? 0)),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    public func configure(item: ListBlockContentItem, style: ListBlockStyle) {
        guard let castedStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle else { return }
        let attributedString = Self.makeAttributedString(item: item, style: style)
        textView.attributedText = attributedString

        imageSize = style == .unordered ? castedStyle.sizeForUnorderedImage : .zero
        widthConstraint?.constant = imageSize.width
        heightConstraint?.constant = imageSize.height
        leftTextViewConstraint?.constant = style == .unordered ? castedStyle.insetBetweenImageAndText : .zero
    }
    
    public func apply(style: EJBlockStyle) {
        guard let style = style as? EJListBlockStyle else { return }
        textView.textColor = style.color
        imageView.image = style.imageForUnorderedList
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    public static func estimatedSize(for item: ListBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let castedStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle else { return .zero }
        var textBoundingWidth = boundingWidth - (castedStyle.insets.left + castedStyle.insets.right)
        textBoundingWidth -= (castedStyle.leftInset + castedStyle.rightInset)
        
        if item.style == .unordered {
            let imageWidth = castedStyle.sizeForUnorderedImage.width
            textBoundingWidth -= (imageWidth + castedStyle.insetBetweenImageAndText)
        }
        
        let string = makeAttributedString(item: item, style: item.style)
        var height = string.textViewHeight(boundingWidth: textBoundingWidth)
        
        if item.style == .unordered && height < castedStyle.sizeForUnorderedImage.height {
            height = castedStyle.sizeForUnorderedImage.height
        }
        
        return CGSize(width: boundingWidth, height: height)
    }

    private static func makeAttributedString(item: ListBlockContentItem, style: ListBlockStyle) -> NSAttributedString {
        let prefix = style == .unordered ? "" : "\(item.index).\t"
        let attributedString = NSMutableAttributedString(string: prefix)
        
        let blockStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle
        if let font = blockStyle?.font {
            attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: prefix.count))
        }
        attributedString.append(item.attributedString!)
        
        let paragraphStyle = NSMutableParagraphStyle()
        let tabSpace = blockStyle?.tabulationSpace ?? Constants.defaultTabSpace
        let tabStop = NSTextTab(textAlignment: .left, location: tabSpace, options: [:])
        paragraphStyle.defaultTabInterval = tabSpace
        paragraphStyle.tabStops = [tabStop]
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.string.count))
        return attributedString
    }
}

///
extension ListItemNativeView {
    struct Constants {
        static let defaultTabSpace: CGFloat = 10
    }
}

