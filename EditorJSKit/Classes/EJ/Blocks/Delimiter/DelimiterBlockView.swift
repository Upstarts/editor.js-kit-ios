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
}
