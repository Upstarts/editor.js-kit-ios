//
//  ParagraphBlockNativeStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 20/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
protocol ParagraphNativeStyle: EJBlockStyle {
    var font: UIFont { get }
}

///
class ParagraphBlockNativeStyle: ParagraphNativeStyle {
    var font: UIFont = .systemFont(ofSize: 18, weight: .thin)
}
