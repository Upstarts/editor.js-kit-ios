//
//  AbstractBlock.swift
//  EditorJSKit_Example
//
//  Created by Иван Глушко on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
protocol AbstractBlockContent: Decodable {}

///
protocol AbstractBlockProtocol: Decodable {
    var type: BlockType { get }
    var data: AbstractBlockContent { get }
}

///
struct AbstractBlock: AbstractBlockProtocol {
    let type: BlockType
    let data: AbstractBlockContent
    
    enum CodingKeys: String, CodingKey { case type, data }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(BlockType.self, forKey: .type)
        
        switch type {
        case .header:
            data = try container.decode(HeaderBlockContent.self, forKey: .data)
        default:
            throw DecodingError.typeMismatch(AbstractBlockContent.self,
                                             DecodingError.Context(
                                                codingPath: [CodingKeys.type],
                                                debugDescription: "Didn't match any of type \(String(describing: BlockType.self))"))
        }
    }
}
