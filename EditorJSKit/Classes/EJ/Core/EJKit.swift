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
    
    open var registeredCustomBlocks: [EJAbstractCustomBlock] = []
    
    /**
     */
    public func register<View: ConfigurableBlockView, Content: EJAbstractBlockContent>(customBlock: EJCustomBlock<View, Content>) {
        registeredCustomBlocks.append(customBlock)
    }
    
    /**
     */
    func retrieveCustomBlock(ofType type: EJAbstractBlockType) -> EJAbstractCustomBlock? {
        return registeredCustomBlocks.first(where: { $0.type.rawValue == type.rawValue })
    }
    
    /**
     */
    public func decode(data: Data) throws -> EJBlocksList {
        let decoder = EJBlocksDecoder(kit: self)
        return try decoder.decode(EJBlocksList.self, from: data)
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
