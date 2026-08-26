//
//  HeaderNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class HeaderNativeContentView: UIView, ConfigurableBlockView {
    
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
    
    public func configure(withItem item: HeaderBlockContentItem, style: EJBlockStyle?) {
        guard let style = style as? EJHeaderBlockStyle else {
            label.text = item.text
            return
        }
        // Normally a no-op: the renderer prepares the cache before the cell is dequeued, because
        // converting HTML here spins a nested run loop that crashes UIKit while the collection
        // view is waiting for a dequeued cell. See issues #31 and #33.
        item.prepareCachedAttributedString(withStyle: style)
        label.attributedText = item.cachedAttributedString

        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        label.textAlignment = style.alignment
    }
    
    public static func estimatedSize(for item: HeaderBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJHeaderBlockStyle else { return .zero }
        item.prepareCachedAttributedString(withStyle: style)
        let newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        let height = item.cachedAttributedString?.height(withConstrainedWidth: newBoundingWidth) ?? .zero
        return CGSize(width: boundingWidth, height: height)
    }
}

