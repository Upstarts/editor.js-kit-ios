//
//  EJHeaderBlockStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 13/06/2019.
//

import UIKit

///
public protocol EJHeaderBlockStyle: EJBlockStyle {
    var alignment: NSTextAlignment { get }
    func font(forHeaderLevel level: Int) -> UIFont
    func topInset(forHeaderLevel level: Int) -> CGFloat
    func bottomInset(forHeaderLevel level: Int) -> CGFloat
}

///
class HeaderBlockNativeStyle: EJHeaderBlockStyle {
    var alignment: NSTextAlignment = .left
    
    func font(forHeaderLevel level: Int) -> UIFont {
        switch level {
        case 1: return UIFont.systemFont(ofSize: 30, weight: .bold)
        case 2: return UIFont.systemFont(ofSize: 24, weight: .bold)
        default: return UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    func topInset(forHeaderLevel level: Int) -> CGFloat {
        return 0
    }
    
    func bottomInset(forHeaderLevel level: Int) -> CGFloat {
        return 0
    }
}
