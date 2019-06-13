//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public struct EJHeaderBlockContent: EJAbstractBlockContent {
    var numberOfItems: Int
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return nil
    }
    
    let text: String
    let level: Int
}

///
public struct EJHeaderContentItem: EJAbstractBlockContentItem {
    let text: String
    let level: Int
}
