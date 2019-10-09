//
//  ListItemView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

open class ListItemNativeView: UIView, EJBlockStyleApplicable {
    public let textView = UITextViewFixed()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle
        
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.alwaysBounceVertical = false
        textView.isScrollEnabled = false
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.leftInset ?? 0),
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.rightInset ?? 0)),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    public func configure(item: ListBlockContentItem, style: ListBlockStyle) {
        let attributedString = ListItemNativeView.makeAttributedString(item: item, style: style)
        textView.attributedText = attributedString
        
    }
    public func apply(style: EJBlockStyle) {
        guard let style = style as? EJListBlockStyle else { return }
        textView.textColor = style.color
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    public static func estimatedSize(for item: ListBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let castedStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle else { return .zero }
        
        var textBoundingWidth = boundingWidth - (castedStyle.insets.left + castedStyle.insets.right)
        textBoundingWidth -= (castedStyle.leftInset + castedStyle.rightInset)
        
        let string = makeAttributedString(item: item, style: item.style)        
        let height = string.textViewHeight(boundingWidth: textBoundingWidth)
        return CGSize(width: boundingWidth, height: height)
    }

    private static func makeAttributedString(item: ListBlockContentItem, style: ListBlockStyle) -> NSAttributedString {
        let prefix = style == .unordered ? "\(Constants.bulletSign)\t" : "\(item.index).\t"
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
        static let bulletSign = "\u{2022}"
        static let defaultTabSpace: CGFloat = 10
    }
}
