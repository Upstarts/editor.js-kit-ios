//
//  LinkBlockNativeStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol LinkNativeStyle: EJBlockStyle {
    var cornerRadius: CGFloat { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    var titleTextAlignment: NSTextAlignment { get }
    var linkFont: UIFont { get }
    var linkColor: UIColor { get }
    var linkTextAlignment: NSTextAlignment { get }
    var descriptionFont: UIFont { get }
    var descriptionColor: UIColor { get }
    var descriptionTextAlignment: NSTextAlignment { get }
    var backgroundColor: UIColor { get }
    var imageCornerRadius: CGFloat { get }
    var imageWidthHeight: CGFloat { get }
    var imageRightInset: CGFloat { get }
}

///
class LinkBlockNativeStyle: LinkNativeStyle {
    var cornerRadius: CGFloat = 3
    var titleFont: UIFont = .systemFont(ofSize: 20)
    var titleColor: UIColor = .black
    var titleTextAlignment: NSTextAlignment = .left
    var linkFont: UIFont = .systemFont(ofSize: 15)
    var linkColor: UIColor = .black
    var linkTextAlignment: NSTextAlignment = .left
    var backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.15)
    var imageCornerRadius: CGFloat = 3
    var descriptionFont: UIFont = .systemFont(ofSize: 18)
    var descriptionColor: UIColor = .black
    var descriptionTextAlignment: NSTextAlignment = .left
    var imageWidthHeight: CGFloat = 70
    var imageRightInset: CGFloat = 5
}
