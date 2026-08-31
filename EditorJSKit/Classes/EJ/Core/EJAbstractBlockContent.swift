//
//  EJAbstractBlockContent.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 30.05.2022.
//

///
public protocol EJAbstractBlockContentItem: Decodable {
    /**
     Parses and caches whatever attributed strings the item needs to be rendered with `style`.

     The renderer calls this before dequeuing a cell, because parsing HTML spins a nested run loop
     and doing that with a dequeued cell outstanding crashes UIKit — see issues #31 and #33.
     Implementations must be idempotent and cheap when the cache is already up to date.
     */
    func prepareCaches(withStyle style: EJBlockStyle?)
}

///
public extension EJAbstractBlockContentItem {
    func prepareCaches(withStyle style: EJBlockStyle?) {}
}

///
public protocol EJAbstractBlockContent: Decodable {
    var numberOfItems: Int { get }
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem?
}

///
public protocol EJAbstractBlockContentSingleItem: EJAbstractBlockContent {
    var item: EJAbstractBlockContentItem { get }
}

///
extension EJAbstractBlockContentSingleItem {
    public var numberOfItems: Int { 1 }
    public func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? { item }
}
