//
//  HeaderCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import UIKit


///
public class HeaderCollectionViewCell: UICollectionViewCell, EJBlockStyleApplicable {
    
    let baseView = UIView()
    let headerView = HeaderNativeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.header)?.insets ?? .zero
        
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
            headerView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            headerView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            headerView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            headerView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
    }
    
    public func configureCell(item: HeaderBlockContentItem) {
        headerView.configure(item: item)
    }
    
    public func apply(style: EJBlockStyle) {
        headerView.apply(style: style)
    }
    
}
