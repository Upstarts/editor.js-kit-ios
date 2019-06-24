//
//  EJKit.swift
//  EditorJSKit
//
//  Created by Ivan Glushko on 12/06/2019.
//

import Foundation

///
open class EJKit {
    public static let shared = EJKit()
    open var style: EJStyle = NativeStyle()
    
    private init() {}
    
    var registeredCustomBlocks: [EJCustomBlock] = []
    
    public func register(customBlock: EJCustomBlock) {
        registeredCustomBlocks.append(customBlock)
    }
}

///
public struct EJCustomBlock {
    public var type: EJAbstractBlockType
    public var contentClass: EJAbstractBlockContent.Type
    
    public init(type: EJAbstractBlockType, contentClass: EJAbstractBlockContent.Type) {
        self.type = type
        self.contentClass = contentClass
    }
}



