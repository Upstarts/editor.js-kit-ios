//
//  LinkNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

open class LinkNativeContentView: UIView, ConfigurableBlockView {
    
    private weak var item: LinkBlockContentItem?
    
    // MARK: - UI Properties
    
    public let titleLabel = UILabel()
    public let linkLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let imageView = UIImageView()
    
    public var hasURL = false
    public var hasDescription = false
    
    private lazy var tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction))
    
    private var style: EJLinkBlockStyle?
    
    // MARK: Constraints
    
    private lazy var imageRightConstraint = imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
    private lazy var imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
    private lazy var descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
    
    /**
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if hasURL { layoutForImageView() }
        if hasDescription { descriptionTopConstraint.constant = UIConstants.descriptionTopOffset }
    }
    
    private func layoutForImageView() {
        guard let style = style else { return }
        imageRightConstraint.constant = -style.imageRightInset
        imageWidthConstraint.isActive = false
        imageHeightConstraint.isActive = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: style.imageWidthHeight),
            imageView.widthAnchor.constraint(equalToConstant: style.imageWidthHeight),
        ])
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(linkLabel)
        addSubview(imageView)
        
        titleLabel.numberOfLines = .zero
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: UIConstants.leftInset),
            titleLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: UIConstants.rightInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.titleTopOffset),
            ])
        
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTopConstraint,
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
            ])
        
        linkLabel.numberOfLines = .zero
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstants.leftInset),
            linkLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: UIConstants.rightInset),
            linkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: UIConstants.linkTopOffset)
            ])
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageRightConstraint,
            imageWidthConstraint,
            imageHeightConstraint
            ])
        
        addGestureRecognizer(tapGR)
    }
    
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        guard let url = item?.link else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: LinkBlockContentItem, style: EJBlockStyle?) {
        self.item = item
        
        // 1. Apply basic style
        backgroundColor = style?.backgroundColor
        layer.cornerRadius = style?.cornerRadius ?? .zero
        
        guard let style = style as? EJLinkBlockStyle else { return }
        
        // 2. Apply content
        item.prepareCachedStrings(withStyle: style)
        
        let titleMutable = NSMutableAttributedString()
        if let titleAtr = item.cachedTitleAttributedString {
            titleMutable.append(titleAtr)
        }
        if let siteNameAtr = item.cachedSiteNameAttributedString {
            let divider = NSAttributedString(string: Constants.divider)
            titleMutable.append(divider)
            titleMutable.append(siteNameAtr)
        }
        if let descriptionAtr = item.cachedDescriptionAttributedString {
            hasDescription = true
            descriptionLabel.attributedText = descriptionAtr
        }
        titleLabel.attributedText = titleMutable
        linkLabel.text = item.formattedLink
        
        if let url = item.image?.url {
            hasURL = true
            DataDownloaderService.downloadFile(at: url) { [weak self] (data, downloadedUrl) in
                guard url == downloadedUrl, let image = UIImage(data: data) else {
                    self?.imageView.image = nil
                    return
                }
                self?.imageView.image = image
            }
        } else {
            imageView.image = nil
        }
        
        // 2. Apply specific style
        self.style = style
        titleLabel.font = style.titleFont
        titleLabel.textColor = style.titleColor
        titleLabel.textAlignment = style.titleTextAlignment

        linkLabel.font = style.linkFont
        linkLabel.textColor = style.linkColor
        linkLabel.textAlignment = style.linkTextAlignment

        imageView.layer.cornerRadius = style.imageCornerRadius
    }
    
    /**
     */
    public static func estimatedSize(for item: LinkBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJLinkBlockStyle else { return .zero }
        let initialBoundingWidth = boundingWidth
        var boundingWidth = boundingWidth - (UIConstants.widthInsets + style.insets.left + style.insets.right)
        if item.image?.url != nil {
            boundingWidth -= (style.imageWidthHeight + style.imageRightInset)
        }
        
        item.prepareCachedStrings(withStyle: style)
        
        let titleMutable = NSMutableAttributedString()
        if let titleAtr = item.cachedTitleAttributedString {
            titleMutable.append(titleAtr)
        }
        if let siteNameAtr = item.cachedSiteNameAttributedString {
            let divider = NSAttributedString(string: Constants.divider)
            titleMutable.append(divider)
            titleMutable.append(siteNameAtr)
        }
        
        var height = titleMutable.height(withConstrainedWidth: boundingWidth)
        
        if let descriptionAtr = item.cachedDescriptionAttributedString {
            height += UIConstants.descriptionTopOffset
            height += descriptionAtr.height(withConstrainedWidth: boundingWidth)
        }
        
        if let formatttedLink = item.formattedLink {
            height += formatttedLink.height(using: style.linkFont)
        }
        
        height += UIConstants.heightInsets
        height = height > style.imageWidthHeight ? height : style.imageWidthHeight + UIConstants.heightInsets
        
        return CGSize(width: initialBoundingWidth, height: height )
    }
}

///
extension LinkNativeContentView {
    struct UIConstants {
        static let titleTopOffset: CGFloat = 9
        static let leftInset: CGFloat = 16
        static let rightInset: CGFloat = -16
        static let linkTopOffset: CGFloat = 7
        static let linkBottomInset: CGFloat = -12
        static let imageMultiplier: CGFloat = 0.7
        static let descriptionTopOffset: CGFloat = 5
        
        static let widthInsets: CGFloat = UIConstants.leftInset + abs(UIConstants.rightInset)
        static let heightInsets: CGFloat = UIConstants.titleTopOffset + UIConstants.linkTopOffset + abs(UIConstants.linkBottomInset)
    }
    
    struct Constants {
        static let divider = " | "
    }
}
