//
//  RawHtmlBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
class RawHtmlBlockContent: EJAbstractBlockContent {
    private var items: [RawHtmlBlockContentItem] = []
    var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [try RawHtmlBlockContentItem(from: decoder)]
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
}

///
public class RawHtmlBlockContentItem: EJAbstractBlockContentItem {
    public let html: String
    public let attributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey { case html }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        html = try container.decode(String.self, forKey: .html)
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.raw) as? RawHtmlNativeStyle {
            attributedString = html.convertHTML(font: style.font)
        } else {
            attributedString = nil
        }
    }
    
}
