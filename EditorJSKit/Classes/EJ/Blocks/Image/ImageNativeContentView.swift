//
//  ImageNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class ImageNativeContentView: UIView, EJBlockStyleApplicable, ConfigurableBlockView {
    
    // MARK: - UI Properties
    public let imageView = UIImageView()
    public let label = UILabel()
    
    private var imageWidth: NSLayoutConstraint?
    private var imageHeight: NSLayoutConstraint?
    
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
        imageWidth = imageView.widthAnchor.constraint(equalToConstant: 0)
        imageHeight = imageView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageWidth!,
            imageHeight!
            ])
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(style?.captionInsets.bottom ?? 0)),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: style?.captionInsets.left ?? 0),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -(style?.captionInsets.right ?? 0))
            ])
        
    }
    
    private func setImage(from data: Data, item: ImageBlockContentItem) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.imageView.image = image
                self.label.isHidden = false
                self.imageView.isHidden = false
                if let imageSize = ImageNativeContentView.imageSize(for: item, containerMaxWidth: self.bounds.width) {
                    self.imageWidth?.constant = imageSize.width
                    self.imageHeight?.constant = imageSize.height
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private static func imageSize(for item: ImageBlockContentItem, containerMaxWidth: CGFloat) -> CGSize? {
        if let data = item.file.imageData, let image = UIImage(data: data) {
            let imageRatio = image.size.width / image.size.height
            if imageRatio >= 1 {
                // album or square
                let imageHeight: CGFloat = image.size.height / UIScreen.main.scale
                let height: CGFloat = min(imageHeight, containerMaxWidth / imageRatio)
                return CGSize(width: height * imageRatio, height: height)
            }
            else {
                // portrait
                var imageWidth = image.size.width / UIScreen.main.scale
                imageWidth = min(imageWidth, containerMaxWidth)
                let height = imageWidth / imageRatio
                return CGSize(width: height * imageRatio, height: height)
            }
        }
        return nil
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: ImageBlockContentItem) {
        if let data = item.file.imageData {
            setImage(from: data, item: item)
            label.attributedText = item.attributedString
            withBackground = item.withBackground
            label.isHidden = false
            imageView.isHidden = false
        }
        else {
            label.isHidden = true
            imageView.isHidden = true
        }
    }
    
    public static func estimatedSize(for item: ImageBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        let style = style ?? EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image)
        let containerMaxWidth: CGFloat = boundingWidth - (style?.insets.left ?? 0) - (style?.insets.right ?? 0)
        var height: CGFloat = .zero
        if let imageSize = self.imageSize(for: item, containerMaxWidth: containerMaxWidth) {
            height += imageSize.height
        }
        if let attributed = item.attributedString {
            height += attributed.height(withConstrainedWidth: containerMaxWidth)
            if let style = style as? EJImageBlockStyle {
                height += style.captionInsets.top + style.captionInsets.bottom
            }
        }
        
        return CGSize(width: boundingWidth, height: height)
    }
    
    // MARK: - EJBlockStyleApplicable conformance
    
    public func apply(style: EJBlockStyle) {
        layer.cornerRadius = style.cornerRadius
        imageView.backgroundColor = .clear
        backgroundColor = .clear
        
        guard let style = style as? EJImageBlockStyle else { return }
        label.textColor = style.captionColor
        label.textAlignment = style.textAlignment
        imageView.layer.cornerRadius = style.imageViewCornerRadius
        
        if withBackground {
            imageView.backgroundColor = style.imageViewBackgroundColor
            backgroundColor = style.backgroundColor
        }
    }
}
