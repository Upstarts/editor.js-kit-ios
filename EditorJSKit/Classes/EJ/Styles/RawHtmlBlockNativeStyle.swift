//
//  RawHtmlBlockNativeStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol EJRawHtmlBlockStyle: EJBlockStyle {
    var font: UIFont { get }
}

///
class RawHtmlBlockNativeStyle: EJRawHtmlBlockStyle {
    var font: UIFont = .systemFont(ofSize: 14)
}
