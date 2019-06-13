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
    var numberOfItems: Int
    
    public static func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockContent {
        let item = try container.decode(HeaderBlockContentItem.self, forKey: .data)
        return HeaderBlockContent(items: [item])
    }
    
    convenience required public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: EJAbstractBlock.CodingKeys.self) {
            let item = try container.decode(HeaderBlockContentItem.self, forKey: .data)
            self.init(items: [item])
        }
        else {
            let item =  try HeaderBlockContentItem(from: decoder)
            self.init(items: [item])
        }
    }
    
    init(items: [HeaderBlockContentItem]) {
        self.items = items
        self.numberOfItems = items.count
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return nil
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
