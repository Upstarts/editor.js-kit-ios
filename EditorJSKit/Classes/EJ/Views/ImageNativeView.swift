//
//  ImageNativeView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class ImageNativeView: UIView, EJBlockStyleApplicable {
    
    // MARK: - UI Properties
    public let imageView = UIImageView()
    public let label = UILabel()
    
    //
    private var withBackground: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image) as? EJImageBlockStyle
        addSubview(imageView)
        addSubview(label)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor,
                                              constant: -(style?.captionInsets.top ?? 0)),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(style?.captionInsets.bottom ?? 0)),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.captionInsets.left ?? 0),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.captionInsets.right ?? 0))
            ])
        
    }
    
    public func apply(style: EJBlockStyle) {
        guard let style = style as? EJImageBlockStyle else { return }
        label.textColor = style.captionColor
        label.textAlignment = style.textAlignment
        imageView.layer.cornerRadius = style.imageViewCornerRadius
        if withBackground {
            imageView.backgroundColor = style.imageViewBackgroundColor
            backgroundColor = style.backgroundColor
        }
        else {
            imageView.backgroundColor = .clear
            backgroundColor = .clear
        }
        layer.cornerRadius = style.cornerRadius
    }
    
    public func configure(item: ImageBlockContentItem) {
        if item.stretched {
            imageView.contentMode = .scaleAspectFill
        }
        else {
            imageView.contentMode = .scaleAspectFit
        }
        if let data = item.file.imageData {
            setImage(from: data, item: item)
            label.attributedText = item.attributedString
            withBackground = item.withBackground
        }
    }
    
    private func setImage(from data: Data, item: ImageBlockContentItem) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    public static func estimatedSize(for item: ImageBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        var size: CGSize?
        let style = style ?? EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image)
        if let data = item.file.imageData, let image = UIImage(data: data), let attributed = item.attributedString {
            var height = image.size.height / UIScreen.main.scale
            height += attributed.height(withConstrainedWidth: boundingWidth)
            if let style = style as? EJImageBlockStyle {
                height += style.captionInsets.top + style.captionInsets.bottom
            }
            size = CGSize(width: boundingWidth, height: height)
        }
        
        return size ?? CGSize(width: boundingWidth, height: 10)
    }
}
