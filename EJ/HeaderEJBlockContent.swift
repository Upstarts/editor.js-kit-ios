//
//  HeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
struct HeaderEJBlockContent: EJAbstractBlockContent {
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return nil
    }
    
    let text: String
    let level: Int
}
