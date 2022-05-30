//
//  ReusableBlockView.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 27.05.2022.
//

import Foundation

///
public protocol ReusableBlockView {
    static var reuseId: String { get }
}

///
public extension ReusableBlockView {
    static var reuseId: String { String(describing: Self.self) }
}
