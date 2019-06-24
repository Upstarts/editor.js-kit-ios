//
//  HeaderCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import UIKit

///
class HeaderView: UIView, EJBlockStyleApplicable {
    
    let label = UILabel()
    var level = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    public func configure(item: HeaderBlockContentItem) {
        label.text = item.text
        level = item.level
    }
    
    public func apply(style: EJBlockStyle) {
        guard let style = style as? EJHeaderBlockStyle else { return }
        let font = style.font(forHeaderLevel: level)
        label.font = font
    }
    
    static func estimatedSize(for item: HeaderBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        var style = style
        if style == nil { style = HeaderBlockNativeStyle() }
        
        guard let castedStyle = style as? HeaderBlockNativeStyle else { return .zero }
        let font = castedStyle.font(forHeaderLevel: item.level)
        return item.text.size(using: font, boundingWidth: boundingWidth)
    }
}


///
public class HeaderCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    
    let baseView = UIView()
    let headerView = HeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        baseView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: baseView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: baseView.rightAnchor),
            headerView.topAnchor.constraint(equalTo: baseView.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor)
            ])
    }
    
    internal func configure(content: HeaderBlockContent) {
        if let item = content.getItem(atIndex: 0) as? HeaderBlockContentItem {
            headerView.configure(item: item)
        }
    }
    
    public func apply(style: EJBlockStyle) {
        headerView.apply(style: style)
    }
    
}
