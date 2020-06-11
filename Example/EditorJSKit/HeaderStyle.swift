//
//  HeaderStyle.swift
//  EditorJSKit_Example
//
//  Created by Vadim Popov on 11.06.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import EditorJSKit

///
struct HeaderStyle: EJHeaderBlockStyle {
    
    let alignment: NSTextAlignment = .left
    
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
