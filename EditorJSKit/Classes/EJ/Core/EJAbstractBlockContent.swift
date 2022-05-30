//
//  EJAbstractBlockContent.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 30.05.2022.
//

///
public protocol EJAbstractBlockContentItem: Decodable {}

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
