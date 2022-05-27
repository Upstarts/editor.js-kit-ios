//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public class HeaderBlockContent: EJAbstractBlockContent {
    public var items: [HeaderBlockContentItem] = []
    public var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [try HeaderBlockContentItem(from: decoder) ]
    }
    
    public func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
}

///
public class HeaderBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case text, level }
    public let text: String
    public let level: Int
    public var attributedString: NSAttributedString?
    
    public init(text: String, level: Int) {
        self.text = text
        self.level = level
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        level = try container.decode(Int.self, forKey: .level)
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.header) as? EJHeaderBlockStyle {
            attributedString = text.convertHTML(font: style.font(forHeaderLevel: level), forceFontFace: true)
        } else {
            attributedString = nil
        }
    }
}
