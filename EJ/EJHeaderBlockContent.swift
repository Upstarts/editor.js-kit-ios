//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
struct HeaderEJBlockContent: EJAbstractBlockContent {
    private var items: [HeaderEJBlockContentItem] = []
    var numberOfItems: Int
    
    public static func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockContent {
        let item = try container.decode(HeaderEJBlockContentItem.self, forKey: .content)
        return HeaderEJBlockContent(items: [item])
    }
    
    private init(items: [HeaderEJBlockContentItem]) {
        self.items = items
        self.numberOfItems = items.count
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        return nil
    }
}

///
struct HeaderEJBlockContentItem: EJAbstractBlockContentItem {
    let text: String
    let level: Int
}

///
public struct EJHeaderContentItem: EJAbstractBlockContentItem {
    let text: String
    let level: Int
}
