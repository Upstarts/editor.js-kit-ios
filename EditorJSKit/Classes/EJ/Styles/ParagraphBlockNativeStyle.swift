//
//  ParagraphBlockNativeStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 20/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol EJParagraphBlockStyle: EJBlockStyle {
    var font: UIFont { get }
    var linkTextAttributes: [NSAttributedString.Key: Any] { get }
}

///
class ParagraphBlockNativeStyle: EJParagraphBlockStyle {
    var font: UIFont = .systemFont(ofSize: 18)
    var linkTextAttributes: [NSAttributedString.Key: Any] = [:]
}
