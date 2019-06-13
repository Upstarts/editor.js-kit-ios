//
//  TitleBlock.swift
//  EditorJSKit_Example
//
//  Created by Иван Глушко on 13/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import EditorJSKit

///
enum BlockType: String, Decodable, EJAbstractBlockType {
    case title
    
    func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockType {
        return try container.decode(BlockType.self, forKey: .type)
    }
}

///
class TitleBlockContent: EJAbstractBlockContent {
    private var items: [TitleContentItem] = []
    var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EJAbstractBlock.CodingKeys.self)
        items = [ try container.decode(TitleContentItem.self, forKey: .data) ]
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return nil
    }
}

///
struct TitleContentItem: EJAbstractBlockContentItem {
    let text: String
}
