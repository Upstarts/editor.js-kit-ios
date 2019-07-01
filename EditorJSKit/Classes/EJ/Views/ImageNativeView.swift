//
//  ImageNativeView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
class ImageNativeView: UIView, EJBlockStyleApplicable {
    
    // MARK: - UI Properties
    private let imageView = UIImageView()
    private let label = UILabel()
    
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
        let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image) as? ImageNativeStyle
        addSubview(imageView)
        addSubview(label)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.captionLeftInset ?? .zero),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.captionRightInset ?? .zero))
            ])
        
    }
    
    func apply(style: EJBlockStyle) {
        guard let style = style as? ImageBlockNativeStyle else { return }
        label.textColor = style.captionColor
        label.textAlignment = style.textAlignment
        imageView.layer.cornerRadius = style.imageViewCornerRadius
        if withBackground { imageView.backgroundColor = style.imageViewBackgroundColor }
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    func configure(content: ImageBlockContent) {
        if let item = content.getItem(atIndex: 0) as? ImageBlockContentItem, let data = item.file.imageData {
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
    
    static func estimatedSize(for item: ImageBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        var size: CGSize?
        
        if let data = item.file.imageData, let image = UIImage(data: data), let attributed = item.attributedString {
            var height = image.size.height / UIScreen.main.scale
            height += attributed.height(withConstrainedWidth: boundingWidth)
            size = CGSize(width: boundingWidth, height: height)
        }
        
        return size ?? CGSize(width: boundingWidth, height: 100)
    }
}
