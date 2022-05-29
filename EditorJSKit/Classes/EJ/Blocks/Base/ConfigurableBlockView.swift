//
//  ConfigurableBlockView.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 27.05.2022.
//

import CoreGraphics

///
public protocol ConfigurableBlockView {
    associatedtype BlockContentItem
    func configure(withItem item: BlockContentItem)
    static func estimatedSize(for item: BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize
}
