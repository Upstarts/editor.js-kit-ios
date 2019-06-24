//
//  DelimiterBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
class DelimiterBlockContent: EJAbstractBlockContent {
    private var items = [DelimiterBlockContentItem()]
    var numberOfItems: Int { return items.count }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
    
    enum CodingKeys: CodingKey {}
}

///
class DelimiterBlockContentItem: EJAbstractBlockContentItem {
    let text = "* * *"
}
