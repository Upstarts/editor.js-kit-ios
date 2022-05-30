//
//  CalloutBlockStyle.swift
//  EditorJSKit_Example
//
//  Created by Vadim Popov on 30.05.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import EditorJSKit
import UIKit

///
protocol CalloutBlockStyle: EJBlockStyle {
    var font: UIFont { get }
    var textColor: UIColor { get }
    var emojiFont: UIFont { get }
}

///
struct CalloutBlockStyleImpl: CalloutBlockStyle {
    let backgroundColor = UIColor(red: 1, green: 0.78, blue: 0, alpha: 0.2)
    let cornerRadius: CGFloat = 6
    let lineSpacing: CGFloat = 10
    let font = UIFont.systemFont(ofSize: 16)
    let textColor = UIColor.black
    let emojiFont = UIFont.systemFont(ofSize: 24)
}
