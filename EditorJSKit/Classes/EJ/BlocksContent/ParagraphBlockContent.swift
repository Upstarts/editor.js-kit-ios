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
    var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [try ParagraphBlockContentItem(from: decoder)]
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
}

///
public class ParagraphBlockContentItem: EJAbstractBlockContentItem {
    public let text: String
    public let attributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey { case text }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.paragraph) as? ParagraphBlockNativeStyle {
            attributedString = text.convertHTML(font: style.font)
        } else {
            attributedString = nil
        }
    }
    
}
