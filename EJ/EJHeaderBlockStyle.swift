//
//  EJHeaderBlockStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 13/06/2019.
//

import Foundation

///
public protocol EJHeaderBlockStyle: EJBlockStyle {
    func font(forHeaderLevel level: Int) -> UIFont
}

///
public class HeaderBlockNativeStyle: EJHeaderBlockStyle {
    
    public init() {}
    
    public func font(forHeaderLevel level: Int) -> UIFont {
        switch level {
        case 1: return UIFont.systemFont(ofSize: 22)
        case 2: return UIFont.systemFont(ofSize: 18)
        default: return UIFont.systemFont(ofSize: 16)
        }
    }
}
