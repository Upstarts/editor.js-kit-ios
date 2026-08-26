//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public class HeaderBlockContent: EJAbstractBlockContentSingleItem {
    public let item: EJAbstractBlockContentItem
    required public init(from decoder: Decoder) throws {
        item = try HeaderBlockContentItem(from: decoder)
    }
}

///
public class HeaderBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case text, level }
    public let text: String
    public let level: Int

    let textCache = EJAttributedTextCache()
    public var cachedAttributedString: NSAttributedString? {
        get { textCache.attributedString }
        set { textCache.store(newValue) }
    }

    public init(text: String, level: Int) {
        self.text = text
        self.level = level
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        level = try container.decode(Int.self, forKey: .level)
    }

    func prepareCachedAttributedString(withStyle style: EJHeaderBlockStyle) {
        textCache.prepare(html: text, font: style.font(forHeaderLevel: level), forceFontFace: true)
    }
}
