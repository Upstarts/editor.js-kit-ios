//
//  EJBlocksList.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public struct EJBlocksList: Decodable {
    public let time: Int
    public var blocks: [EJAbstractBlock]
    public let version: String
    
    enum CodingKeys: String, CodingKey {
        case time, blocks, version
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        version = try container.decode(String.self, forKey: .version)
        blocks = try container.decode([FailableDecodable<EJAbstractBlock>].self, forKey: .blocks).enumerated().compactMap { index, element in
            if element.base == nil {
                print("Block at index: \(index) failed to initialize at decoding phase.")
            }
            return element.base
        }
            
            
    }
}


///
struct FailableDecodable<Base : Decodable> : Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
