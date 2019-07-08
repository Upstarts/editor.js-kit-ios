//
//  ListItemView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

open class ListItemNativeView: UIView, EJBlockStyleApplicable {
    public let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? ListNativeStyle
        
        addSubview(label)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.leftInset ?? .zero),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.rightInset ?? .zero)),
            label.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    public func configure(item: ListBlockContentItem, style: ListBlockStyle) {
        switch style {
        case .unordered:
            let string = NSMutableAttributedString(string: Constants.bulletSign)
            string.append(item.attributedString!)
            label.attributedText = string
        case .ordered:
            let string = NSMutableAttributedString(string: "\(item.index). " )
            string.append(item.attributedString!)
            label.attributedText = string
        }
        
    }
    public func apply(style: EJBlockStyle) {
        guard let style = style as? ListBlockNativeStyle else { return }
        label.textColor = style.color
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    public static func estimatedSize(for item: ListBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let castedStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? ListBlockNativeStyle else { return .zero }
        let font = castedStyle.font
        var textBoundingWidth = boundingWidth - (castedStyle.insets.left + castedStyle.insets.right)
        textBoundingWidth -= (castedStyle.leftInset + castedStyle.rightInset)
        let height = item.text.size(using: font, boundingWidth: textBoundingWidth).height
        return CGSize(width: boundingWidth, height: height)
    }

}

///
extension ListItemNativeView {
    struct Constants {
        static let bulletSign = "\u{2022} "
    }
}
