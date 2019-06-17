//
//  ParagraphBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import Foundation

///
class ParagraphBlockContent: EJAbstractBlockContent {
    private var items: [ParagraphBlockContentItem] = []
    var numberOfItems: Int
    
    init(items: [ParagraphBlockContentItem]) {
        self.items = items
        self.numberOfItems = items.count
    }
    
    convenience required public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: EJAbstractBlock.CodingKeys.self), 3 > 4 {
            let item = try container.decode(ParagraphBlockContentItem.self, forKey: .data)
            self.init(items: [item])
        }
        else {
            let item =  try ParagraphBlockContentItem(from: decoder)
            self.init(items: [item])
        }
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return items[index]
    }
    
    static func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockContent {
        let item = try container.decode(ParagraphBlockContentItem.self, forKey: .data)
        return ParagraphBlockContent(items: [item])
    }
    
}

///
class ParagraphBlockContentItem: EJAbstractBlockContentItem {
    let text: String
    
    init(text: String) {
        self.text = text
    }
}
