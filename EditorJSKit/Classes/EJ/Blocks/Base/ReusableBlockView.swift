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
    // Module-qualified, like `BaseBlockView.reuseId`: a bare type name can collide with a
    // same-named type from another module and hand back the wrong cell class (issue #35).
    static var reuseId: String { String(reflecting: Self.self) }
}
