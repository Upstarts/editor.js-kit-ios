//
//  DelimiterBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class DelimiterBlockContent: EJAbstractBlockContentSingleItem {
    public let item: EJAbstractBlockContentItem = DelimiterBlockContentItem()
    enum CodingKeys: CodingKey {}
}

///
public class DelimiterBlockContentItem: EJAbstractBlockContentItem {
    let text = "\u{FF0A} \u{FF0A} \u{FF0A}"
}
