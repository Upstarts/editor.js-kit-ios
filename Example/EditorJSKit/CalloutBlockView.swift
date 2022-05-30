//
//  CalloutBlockView.swift
//  EditorJSKit_Example
//
//  Created by Vadim Popov on 30.05.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import EditorJSKit
import UIKit

///
final class CalloutBlockView: UIView, EJBlockView {

    ///
    typealias BlockContentItem = CalloutBlockContentItem
    
    private let emoji = UILabel()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     */
    private func setupViews() {
        let padding: CGFloat = 10
        
        addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emoji.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            emoji.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(label)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: emoji.rightAnchor, constant: padding),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }

    /**
     */
    func configure(withItem item: CalloutBlockContentItem, style: EJBlockStyle?) {
        emoji.text = item.emoji
        label.text = item.text
        
        guard let style = style as? CalloutBlockStyle else { return }
        
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        emoji.font = style.emojiFont
        label.font = style.font
        label.textColor = style.textColor
    }
    
    /**
     */
    static func estimatedSize(for item: CalloutBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        return CGSize(width: boundingWidth, height: 100)
    }
}
