//
//  EJKit.swift
//  EditorJSKit
//
//  Created by Ivan Glushko on 12/06/2019.
//

import Foundation

///
open class EJKit {
    static let shared = EJKit()
    var style: EJStyle?
    
    private var registeredCustomBlocks: [EJCustomBlock] = []
    
    func register(customBlock: EJCustomBlock) {
        registeredCustomBlocks.append(customBlock)
    }
}

///
struct EJCustomBlock {
    var type: EJAbstractBlockType
    var contentClass: EJAbstractBlockContent.Type
    var contentItemClass: EJAbstractBlockContentItem.Type
}

