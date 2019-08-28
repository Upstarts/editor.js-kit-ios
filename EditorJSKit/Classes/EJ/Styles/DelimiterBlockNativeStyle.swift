//
//  DelimiterBlockStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol DelimiterNativeStyle: EJBlockStyle {
    var font: UIFont { get }
    var textAlignment: NSTextAlignment { get }
    var color: UIColor { get }
    var labelInsets: UIEdgeInsets { get }
}

///
class DelimiterBlockNativeStyle: DelimiterNativeStyle {
    var font: UIFont = .systemFont(ofSize: 15, weight: .regular)
    var textAlignment: NSTextAlignment = .center
    var color: UIColor = .black
    var labelInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}


