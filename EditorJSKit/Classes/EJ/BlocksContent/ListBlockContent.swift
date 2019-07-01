//
//  ListBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
enum ListBlockStyle: String, Decodable {
    case unordered
    case ordered
}

///
class ListBlockContent: EJAbstractBlockContent {
    public var style: ListBlockStyle
    private var items: [ListBlockContentItem]
    var numberOfItems: Int { return items.count }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }
    
    enum CodingKeys: String, CodingKey { case style, items }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        style = try container.decode(ListBlockStyle.self, forKey: .style)
        if let items = try? container.decode([String].self, forKey: .items) {
            self.items = items.enumerated().map { return ListBlockContentItem(text: $1, index: $0 + 1) }
        } else {
            throw DecodingError.typeMismatch([ListBlockContentItem].self,
                                             DecodingError.Context(codingPath: [CodingKeys.items],
                                             debugDescription: "Couldn't parse items"))}
        
    }
    
}

///
class ListBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey {  case text }
    let text: String
    let index: Int
    
    public let attributedString: NSAttributedString?
    
    init(text: String, index: Int) {
        self.text = text
        self.index = index
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? ListNativeStyle {
            attributedString = text.convertHTML(font: style.font)
        } else {
            attributedString = nil
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        index = 0
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.list) as? ListNativeStyle {
            attributedString = text.convertHTML(font: style.font)
        } else {
            attributedString = nil
        }
    }
}
