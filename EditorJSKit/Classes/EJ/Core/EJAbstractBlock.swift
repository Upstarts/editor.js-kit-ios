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
}

///
public protocol EJAbstractBlockProtocol: Decodable {
    var type: EJAbstractBlockType { get }
    var data: EJAbstractBlockContent { get }
}

///
open class EJAbstractBlock: EJAbstractBlockProtocol {
    public var type: EJAbstractBlockType
    public var data: EJAbstractBlockContent
    
    public enum CodingKeys: String, CodingKey { case type, data }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let kit = (decoder.userInfo[EJKit.Keys.kit.codingUserInfo] as? EJKit) ?? .shared
        
        // Loop through custom blocks
        for customBlock in kit.registeredCustomBlocks {
            guard let type = try? customBlock.type.decode(container: container) else { continue }
            guard let data = try? customBlock.contentClass.init(from: decoder) else {
                throw DecodingError.typeMismatch(
                    EJAbstractBlockContent.self,
                    DecodingError.Context(
                        codingPath: [CodingKeys.type],
                        debugDescription: "Block's content type didn't match declared type \(type.rawValue)"))
            }
            self.type = type
            self.data = data
            return
        }
        
        if let type = try? container.decode(EJNativeBlockType.self, forKey: .type) {
            self.type = type
            switch type {
            case .header:
                self.data = try container.decode(HeaderBlockContent.self, forKey: .data)
            case .image:
                self.data = try container.decode(ImageBlockContent.self, forKey: .data)
            case .list:
                self.data = try container.decode(ListBlockContent.self, forKey: .data)
            case .linkTool:
                self.data = try container.decode(LinkBlockContent.self, forKey: .data)
            case .delimiter:
                self.data = try container.decode(DelimiterBlockContent.self, forKey: .data)
            case .paragraph:
                self.data = try container.decode(ParagraphBlockContent.self, forKey: .data)
            case .raw:
                self.data = try container.decode(RawHtmlBlockContent.self, forKey: .data)
            }
            return
        }
        
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [CodingKeys.type],
                debugDescription: "Unable to parse block - no native or custom type found"))
    }
    
}
