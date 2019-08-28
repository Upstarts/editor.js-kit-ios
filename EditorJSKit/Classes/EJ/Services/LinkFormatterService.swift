//
//  LinkFormatter.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public protocol LinkFormatterServiceProtocol {
    static func format(link: URL) -> String
}

///
class LinkFormatterService: LinkFormatterServiceProtocol {
    
    static func format(link: URL) -> String {
        let pattern = "https://|http://"
        // count of https://
        let count = 8
        let urlString = NSMutableString(string: link.absoluteString)
        let range = NSRange(location: 0, length: count)
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        regex.replaceMatches(in: urlString, options: [], range: range, withTemplate: "")
        return String(urlString)
    }
}
