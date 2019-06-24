//
//  EJConfigurableView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 13/06/2019.
//

import UIKit

///
public protocol EJConfigurableView {
    associatedtype Model: EJAbstractBlockContentItem
    
    func configure(withModel model: Model)
}
