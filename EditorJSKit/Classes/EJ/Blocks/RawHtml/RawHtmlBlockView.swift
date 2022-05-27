//
//  RawHtmlBlockView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

public class RawHtmlBlockView: BaseBlockView<RawHtmlNativeContentView> {
    override var blockType: EJAbstractBlockType { EJNativeBlockType.raw }
}
