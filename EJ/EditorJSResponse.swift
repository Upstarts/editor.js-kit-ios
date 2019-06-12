//
//  EditorJSResponse.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import EditorJSKit

///
struct EditorJSResponse: Decodable {
    let time: Int
    let blocks: [EJAbstractBlock]
    let version: String
}
