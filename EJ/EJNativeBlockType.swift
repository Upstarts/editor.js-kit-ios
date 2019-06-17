//
//  EJNativeBlockType.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public protocol EJAbstractBlockType: Decodable {
    var rawValue: String { get }
    init?(rawValue: String)
    func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockType
}

///
public enum EJNativeBlockType: String, EJAbstractBlockType {
    case paragraph
    case header
    case delimeter
    
    public func decode(container: KeyedDecodingContainer<EJAbstractBlock.CodingKeys>) throws -> EJAbstractBlockType {
        return try container.decode(EJNativeBlockType.self, forKey: .type)
    }
}
