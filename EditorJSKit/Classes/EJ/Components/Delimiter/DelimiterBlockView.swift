//
//  DelimiterStarsCollectionViewCell.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class DelimiterBlockView: BaseBlockView<DelimiterNativeContentView> {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        let insets = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.delimiter)?.insets ?? .zero

        baseView.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blockView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            blockView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            blockView.topAnchor.constraint(equalTo: baseView.topAnchor),
            blockView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor)
            ])
    }
}
