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
    var lineSpacing: CGFloat { get }
}

///
public extension EJBlockStyle {
    var backgroundColor: UIColor { return .clear}
    var insets: UIEdgeInsets { return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) }
    var cornerRadius: CGFloat { return 0 }
    var lineSpacing: CGFloat { return 4 }
}

///
public protocol EJStyleProtocol {
    var blockStyles: [BlockStyle] { get }
    func setStyle(style: EJBlockStyle, for blockType: EJAbstractBlockType)
    func getStyle(forBlockType: EJAbstractBlockType) -> EJBlockStyle?
    
    var defaultItemsLineSpacing: CGFloat { get set }
    var defaultSectionInsets: UIEdgeInsets { get set }
    var defaultItemSize: CGSize { get set }
}

///
open class EJStyle: EJStyleProtocol {
    public var blockStyles: [BlockStyle]
    
    open var defaultItemsLineSpacing: CGFloat = 4
    open var defaultSectionInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    open var defaultItemSize: CGSize = .zero
    
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
