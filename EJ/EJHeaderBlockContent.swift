//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
struct HeaderBlockContent: EJAbstractBlockContent {
    private var items: [HeaderBlockContentItem] = []
    var numberOfItems: Int
    
    public static func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockContent {
        let item = try container.decode(HeaderBlockContentItem.self, forKey: .data)
        return HeaderBlockContent(items: [item])
    }
    
    private init(items: [HeaderBlockContentItem]) {
        self.items = items
        self.numberOfItems = items.count
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return nil
    }
}

///
class HeaderBlockContentItem: EJAbstractBlockContentItem {
    let text: String
    let level: Int
    
    init(text: String, level: Int) {
        self.text = text
        self.level = level
    }
}
