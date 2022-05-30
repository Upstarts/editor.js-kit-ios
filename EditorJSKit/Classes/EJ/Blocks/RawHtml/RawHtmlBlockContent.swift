//
//  RawHtmlBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class RawHtmlBlockContent: EJAbstractBlockContentSingleItem {
    public let item: EJAbstractBlockContentItem
    
    public required init(from decoder: Decoder) throws {
        item = try RawHtmlBlockContentItem(from: decoder)
    }
}

///
public class RawHtmlBlockContentItem: EJAbstractBlockContentItem {
    public let html: String
    var cachedAttributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey { case html }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        html = try container.decode(String.self, forKey: .html)
    }
}
