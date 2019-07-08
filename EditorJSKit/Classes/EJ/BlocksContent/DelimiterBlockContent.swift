//
//  DelimiterBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class DelimiterBlockContent: EJAbstractBlockContent {
    public var items = [DelimiterBlockContentItem()]
    public var numberOfItems: Int { return items.count }
    
    public func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
    
    enum CodingKeys: CodingKey {}
}

///
public class DelimiterBlockContentItem: EJAbstractBlockContentItem {
    let text = "\u{FF0A} \u{FF0A} \u{FF0A}"
}
