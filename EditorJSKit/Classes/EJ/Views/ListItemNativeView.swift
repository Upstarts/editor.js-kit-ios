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
        let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle
        
        addSubview(label)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.leftInset ?? 0),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.rightInset ?? 0)),
            label.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    public func configure(item: ListBlockContentItem, style: ListBlockStyle) {
        switch style {
        case .unordered:
            let string = NSMutableAttributedString(string: "\(Constants.bulletSign)\t")
            string.append(item.attributedString!)
            label.attributedText = string
        case .ordered:
            let string = NSMutableAttributedString(string: "\(item.index).\t" )
            string.append(item.attributedString!)
            label.attributedText = string
        }
        
    }
    public func apply(style: EJBlockStyle) {
        guard let style = style as? EJListBlockStyle else { return }
        label.textColor = style.color
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    public static func estimatedSize(for item: ListBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let castedStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? EJListBlockStyle else { return .zero }
        
        var textBoundingWidth = boundingWidth - (castedStyle.insets.left + castedStyle.insets.right)
        textBoundingWidth -= (castedStyle.leftInset + castedStyle.rightInset)
        
        var string: NSMutableAttributedString!
        switch item.style {
        case .unordered:
            string = NSMutableAttributedString(string: "\(Constants.bulletSign)\t")
            string.append(item.attributedString!)
        case .ordered:
            string = NSMutableAttributedString(string: "\(item.index).\t")
            string.append(item.attributedString!)
        }
        
        let height = string.labelHeight(boundingWidth: textBoundingWidth)
        return CGSize(width: boundingWidth, height: height)
    }

}

///
extension ListItemNativeView {
    struct Constants {
        static let bulletSign = "\u{2022} "
    }
}
