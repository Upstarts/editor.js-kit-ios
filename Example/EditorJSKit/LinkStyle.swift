//
//  LinkStyle.swift
//  EditorJSKit_Example
//
//  Created by Vadim Popov on 27.05.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import EditorJSKit

///
class LinkBlockStyle: EJLinkBlockStyle {
    var cornerRadius: CGFloat = 3
    var titleFont: UIFont = .systemFont(ofSize: 20, weight: .medium)
    var titleColor: UIColor = .black
    var titleTextAlignment: NSTextAlignment = .left
    var linkFont: UIFont = .systemFont(ofSize: 15)
    var linkColor: UIColor = .gray
    var linkTextAlignment: NSTextAlignment = .left
    var backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.15)
    var imageCornerRadius: CGFloat = 3
    var descriptionFont: UIFont = .systemFont(ofSize: 15)
    var descriptionColor: UIColor = .black
    var descriptionTextAlignment: NSTextAlignment = .left
    var imageWidthHeight: CGFloat = 70
    var imageRightInset: CGFloat = 5
}
