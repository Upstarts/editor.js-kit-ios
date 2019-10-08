//
//  ImageBlockNativeStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol EJImageBlockStyle: EJBlockStyle {
    var backgroundColor: UIColor { get }
    var font: UIFont { get }
    var captionColor: UIColor { get }
    var textAlignment: NSTextAlignment { get }
    var cornerRadius: CGFloat { get }
    var captionInsets: UIEdgeInsets { get }
    var imageViewCornerRadius: CGFloat { get }
    var imageViewBackgroundColor: UIColor { get }
}

///
class ImageBlockNativeStyle: EJImageBlockStyle  {
    var imageViewBackgroundColor = UIColor(red: 97/255, green: 199/255, blue: 243/255, alpha: 1)
    var font = UIFont.systemFont(ofSize: 20)
    var captionColor: UIColor = .black
    var textAlignment: NSTextAlignment = .left
    var imageViewCornerRadius: CGFloat = 5
    var captionInsets: UIEdgeInsets = .zero
}
