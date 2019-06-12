//
//  EJAbstractBlock.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
protocol EJAbstractBlockContentItem {}

///
protocol EJAbstractBlockContent: Decodable {
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem?
}

///
protocol EJAbstractBlockProtocol: Decodable {
    associatedtype D where D: EJAbstractBlockType
    
    var type: D { get }
    var content: EJAbstractBlockContent { get }
    var numberOfItems: Int { get }
}

///
open class EJAbstractBlock<T: EJAbstractBlockType>: EJAbstractBlockProtocol {
    typealias D = T
    let type: T
    let content: EJAbstractBlockContent
    let numberOfItems: Int
    
    enum CodingKeys: String, CodingKey { case type, data }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(T.self, forKey: .type)
        
        switch type.rawValue {
        case :
            data = try container.decode(HeaderBlockContent.self, forKey: .data)
        case .
        default:
            throw DecodingError.typeMismatch(EJAbstractBlockContent.self,
                                             DecodingError.Context(
                                                codingPath: [CodingKeys.type],
                                                debugDescription: "Didn't match any of type \(String(describing: EJNativeBlockType.self))"))
        }
    }
    
    convenience init(type: EJAbstractBlockType)
    
}
