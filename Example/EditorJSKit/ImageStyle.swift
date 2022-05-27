//
//  ImageStyle.swift
//  EditorJSKit_Example
//
//  Created by Vadim Popov on 27.05.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import EditorJSKit

///
class ImageBlockStyle: EJImageBlockStyle  {
    var backgroundColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
    var imageViewBackgroundColor = UIColor(red: 97/255, green: 199/255, blue: 243/255, alpha: 1)
    var font = UIFont.systemFont(ofSize: 14)
    var captionColor: UIColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
    var textAlignment: NSTextAlignment = .center
    var imageViewCornerRadius: CGFloat = 5
    var captionInsets = UIEdgeInsets(top: 10, left: .zero, bottom: .zero, right: .zero)
}
