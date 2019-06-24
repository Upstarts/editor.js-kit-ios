//
//  EJStyle.swift
//  EditorJSKit
//
//  Created by Ivan Glushko on 12/06/2019.
//

import UIKit

///
public typealias BlockStyle = (type: EJAbstractBlockType, blockStyle: EJBlockStyle)

///
public protocol EJBlockStyle {
    var backgroundColor: UIColor { get }
    var insets: UIEdgeInsets { get }
    var cornerRadius: CGFloat { get }
}

///
extension EJBlockStyle {
    public var backgroundColor: UIColor { return .clear}
    public var insets: UIEdgeInsets { return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10 )}
    public var cornerRadius: CGFloat { return 0 }
}

///
public protocol EJStyleProtocol {
    var blockStyles: [BlockStyle] { get }
    func setStyle(style: EJBlockStyle, for blockType: EJAbstractBlockType)
    func getStyle(forBlockType: EJAbstractBlockType) -> EJBlockStyle?
}

///
open class EJStyle: EJStyleProtocol {
    public var blockStyles: [BlockStyle]
    
    public func setStyle(style: EJBlockStyle, for blockType: EJAbstractBlockType) {
        blockStyles.enumerated().forEach { (index, blockStyle) in
            guard blockStyle.type.rawValue == blockType.rawValue else { return }
            blockStyles.remove(at: index)
        }
        blockStyles.append((blockType, style))
    }
    
    public func getStyle(forBlockType: EJAbstractBlockType) -> EJBlockStyle? {
        return blockStyles.filter { $0.type.rawValue == forBlockType.rawValue}.first?.blockStyle
    }
    
    public init(blockStyles: [BlockStyle]? = nil) {
        self.blockStyles = blockStyles ?? []
    }
    
}
