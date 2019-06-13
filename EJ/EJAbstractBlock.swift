//
//  EJAbstractBlock.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public protocol EJAbstractBlockContentItem: Decodable {}

///
public protocol EJAbstractBlockContent: Decodable {
    var numberOfItems: Int { get }
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem?
    static func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockContent
}

///
public protocol EJAbstractBlockProtocol: Decodable {
    var type: EJAbstractBlockType { get }
    var content: EJAbstractBlockContent { get }
}

///
open class EJAbstractBlock: EJAbstractBlockProtocol {
    public var type: EJAbstractBlockType
    public var content: EJAbstractBlockContent
    
    public enum CodingKeys: String, CodingKey { case type, content }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let type = try? container.decode(EJNativeBlockType.self, forKey: .type) {
            self.type = type
            switch type {
            case .header:
                self.content = try container.decode(HeaderEJBlockContent.self, forKey: .content)
                break
            case .paragraph:
                throw DecodingError.typeMismatch(
                    EJAbstractBlockContent.self,
                    DecodingError.Context(
                        codingPath: [CodingKeys.content],
                        debugDescription: "Content parsing of native block type \"\(type.rawValue)\" is not implemented"))
            }
            return
        }
            
        // Loop through custom blocks
        for customBlock in EJKit.shared.registeredCustomBlocks {
            guard let type = try? customBlock.type.decode(container: container) else { continue }
            guard let content = try? customBlock.contentClass.decode(container: container) else {
                throw DecodingError.typeMismatch(
                    EJAbstractBlockContent.self,
                    DecodingError.Context(
                        codingPath: [CodingKeys.type],
                        debugDescription: "Block's content type didn't match declared type \(type.rawValue)"))
            }
            self.type = type
            self.content = content
            break
        }
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [CodingKeys.type],
                debugDescription: "Unable to parse block - no native or custom type found"))
    }
    
}
