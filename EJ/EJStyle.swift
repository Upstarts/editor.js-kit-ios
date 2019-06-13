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
protocol EJStyleProtocol {
    var blockStyles: [BlockStyle] { get }
    func setStyle(style: EJBlockStyle, for blockType: EJNativeBlockType)
    func style(forBlockType: EJAbstractBlockType) -> EJBlockStyle
}

///
open class EJStyle: EJStyleProtocol {
    public var blockStyles: [BlockStyle] = []
    
    public func setStyle(style: EJBlockStyle, for blockType: EJNativeBlockType) {}
    
    public func style(forBlockType: EJAbstractBlockType) -> EJBlockStyle {
        return "3232"
    }
    
}

extension String: EJBlockStyle {}
