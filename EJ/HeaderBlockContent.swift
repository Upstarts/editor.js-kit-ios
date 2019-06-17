//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
class HeaderBlockContent: EJAbstractBlockContent {
    private var items: [HeaderBlockContentItem] = []
    var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [ try HeaderBlockContentItem(from: decoder) ]
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
}

///
class HeaderBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case text, level }
    let text: String
    let level: Int
    
    init(text: String, level: Int) {
        self.text = text
        self.level = level
    }
}
