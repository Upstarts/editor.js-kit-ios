//
//  LinkNativeView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

class LinkNativeView: UIView {
    // MARK: - UI Properties
    private let titleLabel = UILabel()
    private let linkLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    
    private var hasURL = false
    private var hasDescription = false
    
    // Constraints
    private lazy var imageRightConstraint = imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: .zero)
    private lazy var imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
    private lazy var descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
    
    /**
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasURL { layoutForImageView() }
        if hasDescription { descriptionTopConstraint.constant = UIConstants.descriptionTopOffset }
    }
    
    private func layoutForImageView() {
        guard let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.linkTool) as? LinkNativeStyle else { return }
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
        
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: UIConstants.leftInset),
            titleLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: UIConstants.rightInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.titleTopOffset),
            ])
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTopConstraint,
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
            ])
        
        linkLabel.numberOfLines = 0
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
        
        
    }
    
    public func configure(item: LinkBlockContentItem, formattedLink: String) {
        let titleMutable = NSMutableAttributedString()
        if let titleAtr = item.titleAttributedString {
            titleMutable.append(titleAtr)
        }
        if let siteNameAtr = item.siteNameAttributedString {
            let divider = NSAttributedString(string: Constants.divider)
            titleMutable.append(divider)
            titleMutable.append(siteNameAtr)
        }
        if let descriptionAtr = item.descriptionAttributedString {
            hasDescription = true
            descriptionLabel.attributedText = descriptionAtr
        }
        titleLabel.attributedText = titleMutable
        linkLabel.text = formattedLink
        
        if let url = item.image?.url {
            hasURL = true
            DataDownloaderService.downloadFile(at: url) { (data) in
                guard let image = UIImage(data: data) else { return }
                self.imageView.image = image
            }
        }
        
    }
    
    public func apply(style: EJBlockStyle) {
        guard let style = style as? LinkBlockNativeStyle else { return }
        titleLabel.textColor = style.titleColor
        titleLabel.textAlignment = style.titleTextAlignment
        linkLabel.font = style.linkFont
        linkLabel.textColor = style.linkColor
        linkLabel.textAlignment = style.linkTextAlignment
        imageView.layer.cornerRadius = style.imageCornerRadius
        //
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
    }
    
    static func estimatedSize(for item: LinkBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let castedStyle = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.linkTool) as? LinkBlockNativeStyle else { return .zero }
        let initialBoundingWidth = boundingWidth
        var boundingWidth = boundingWidth - (UIConstants.widthInsets + castedStyle.insets.left + castedStyle.insets.right)
        if item.image?.url != nil {
            boundingWidth -= (castedStyle.imageWidthHeight + castedStyle.imageRightInset)
        }
        
        let titleMutable = NSMutableAttributedString()
        if let titleAtr = item.titleAttributedString {
            titleMutable.append(titleAtr)
        }
        if let siteNameAtr = item.siteNameAttributedString {
            let divider = NSAttributedString(string: Constants.divider)
            titleMutable.append(divider)
            titleMutable.append(siteNameAtr)
        }
        
        
        var height = titleMutable.height(withConstrainedWidth: boundingWidth)
        
        if let descriptionAtr = item.descriptionAttributedString {
            height += UIConstants.descriptionTopOffset
            height += descriptionAtr.height(withConstrainedWidth: boundingWidth)
        }
   
        height += castedStyle.linkFont.lineHeight
        height += UIConstants.heightInsets
        height = height > castedStyle.imageWidthHeight ? height : castedStyle.imageWidthHeight + UIConstants.heightInsets
        
        return CGSize(width: initialBoundingWidth, height: height )
    }
    
}

///
extension LinkNativeView {
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
