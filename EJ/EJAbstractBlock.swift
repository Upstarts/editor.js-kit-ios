//
//  EJAbstractBlock.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public protocol EJAbstractBlockContentItem {}

///
public protocol EJAbstractBlockContent: Decodable {
    var numberOfItems: Int { get }
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem?
}

///
public protocol EJAbstractBlockProtocol: Decodable {
    associatedtype D where D: EJAbstractBlockType
    
    var type: D { get }
    var content: EJAbstractBlockContent? { get }
}

///
open class EJAbstractBlock<T: EJAbstractBlockType>: EJAbstractBlockProtocol {
    public typealias D = T
    public let type: T
    public let content: EJAbstractBlockContent?
    
    enum CodingKeys: String, CodingKey { case type, content, numberOfItems }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(T.self, forKey: .type)
        content = nil
        
//        switch type.rawValue {
//        default:
//            throw DecodingError.typeMismatch(EJAbstractBlockContent.self,
//                                             DecodingError.Context(
//                                                codingPath: [CodingKeys.type],
//                                                debugDescription: "Didn't match any of type \(String(describing: EJNativeBlockType.self))"))
//        }
    }
    
}
