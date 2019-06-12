//
//  EJBlockType.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public protocol EJAbstractBlockType {
    var rawValue: String { get }
    init?(rawValue: String)
}

///
public enum EJNativeBlockType: String , Decodable, EJAbstractBlockType {
    case paragraph
    case header
}
