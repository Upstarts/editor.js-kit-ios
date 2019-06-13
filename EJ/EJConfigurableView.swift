//
//  EJConfigurableView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 13/06/2019.
//

import Foundation

///
public protocol EJConfigurableView {
    associatedtype Model: EJAbstractBlockContentItem
    
    func configure(withModel model: Model)
}

///
class HeaderView: UIView {
    private weak var model: HeaderBlockContentItem?
    private let label = UILabel()
}

///
extension HeaderView: EJConfigurableView {
    typealias Model = HeaderBlockContentItem
    
    func configure(withModel model: HeaderBlockContentItem) {
        self.model = model
        label.text = model.text
    }
}

///
extension HeaderView: EJBlockStyleApplicable {
    
    func apply(style: EJBlockStyleApplicable) {
        guard let model = self.model, let headerStyle = style as? EJHeaderBlockStyle else { return }
        label.font = headerStyle.font(forHeaderLevel: model.level)
    }
}
