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
    
    init() {}
    
    open var registeredCustomBlocks: [EJCustomBlock] = []
    
    /**
     */
    public func register(customBlock: EJCustomBlock) {
        registeredCustomBlocks.append(customBlock)
    }
    
    /**
     */
    public func decode(data: Data) throws -> EJBlocksList {
        let decoder = EJBlocksDecoder(kit: self)
        return try decoder.decode(EJBlocksList.self, from: data)
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

///
extension EJKit {
    
    ///
    enum Keys: String {
        case kit
        
        var codingUserInfo: CodingUserInfoKey {
            return CodingUserInfoKey(rawValue: rawValue)!
        }
    }
}
