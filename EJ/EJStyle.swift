//
//  EJStyle.swift
//  EditorJSKit
//
//  Created by Ivan Glushko on 12/06/2019.
//

import Foundation

///
public typealias BlockStyle = (EJAbstractBlockType,EJBlockStyle)

///
public protocol EJBlockStyle {}

///
public protocol EJStyleProtocol {
    var blockStyles: [BlockStyle] { get }
    func setStyle(style: EJBlockStyle, for blockType: EJNativeBlockType)
}

///
class EJStyle: EJStyleProtocol {
    var blockStyles: [BlockStyle] = []
    
    func setStyle(style: EJBlockStyle, for blockType: EJNativeBlockType) {
        print("some")
    }
    
    
}
