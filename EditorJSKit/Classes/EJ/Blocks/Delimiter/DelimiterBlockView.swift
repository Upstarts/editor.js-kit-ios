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
    
    override var blockType: EJAbstractBlockType { EJNativeBlockType.delimiter }
    
    override func setupBlockView() {
        let insets = EJKit.shared.style.getStyle(forBlockType: blockType)?.insets ?? .zero

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
