//
//  EditorJSResponse.swift
//  EditorJSKit_Example
//
//  Created by Иван Глушко on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
struct EditorJSResponse: Decodable {
    let time: Int
    let blocks: [AbstractBlock]
    let version: String
}
