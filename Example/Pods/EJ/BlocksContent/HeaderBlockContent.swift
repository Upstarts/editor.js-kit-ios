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
    var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [try HeaderBlockContentItem(from: decoder) ]
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
}

///
open class HeaderBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case text, level }
    let text: String
    let level: Int
    public var attributedString: NSAttributedString?
    
    init(text: String, level: Int) {
        self.text = text
        self.level = level
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        level = try container.decode(Int.self, forKey: .level)
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.header) as? EJHeaderBlockStyle {
            let newText = "<b>\(text)</b>"
            attributedString = newText.convertHTML(font: style.font(forHeaderLevel: level))
        } else {
            attributedString = nil
        }
    }
}
