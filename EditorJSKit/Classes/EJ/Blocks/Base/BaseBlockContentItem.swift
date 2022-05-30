//
//  BaseBlockContentItem.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 30.05.2022.
//

import Foundation

///
public struct BlockContent {
    
    ///
    public struct Single<ContentItem: EJAbstractBlockContentItem>: EJAbstractBlockContentSingleItem {
        public let item: EJAbstractBlockContentItem
        
        ///
        private enum CodingKeys: String, CodingKey {
            case data
        }
        
        public init(from decoder: Decoder) throws {
            if let item = try? ContentItem(from: decoder) {
                self.item = item
            } else {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                item = try container.decode(ContentItem.self, forKey: .data)
            }
        }
    }
}
