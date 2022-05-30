//
//  ParagraphBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import Foundation

///
public class ParagraphBlockContent: EJAbstractBlockContentSingleItem {
    public let item: EJAbstractBlockContentItem
    
    required public init(from decoder: Decoder) throws {
        item = try ParagraphBlockContentItem(from: decoder)
    }
}

///
public class ParagraphBlockContentItem: EJAbstractBlockContentItem {
    public let text: String
    let htmlReadyText: String
    public var cachedAttributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey { case text }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        htmlReadyText = text.replacingOccurrences(of: "\n", with: "<br>")
    }
}
