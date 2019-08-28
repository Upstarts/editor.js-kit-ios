//
//  ListBlockStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol ListNativeStyle: EJBlockStyle {
    var font: UIFont { get }
    var color: UIColor { get }
    var leftInset: CGFloat { get }
    var rightInset: CGFloat { get }
}

///
class ListBlockNativeStyle: ListNativeStyle {
    var font = UIFont.systemFont(ofSize: 18)
    var color = UIColor.black
    var leftInset: CGFloat = 0
    var rightInset: CGFloat = 0
}
