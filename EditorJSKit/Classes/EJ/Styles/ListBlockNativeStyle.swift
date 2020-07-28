//
//  ListBlockStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public protocol EJListBlockStyle: EJBlockStyle {
    var font: UIFont { get }
    var color: UIColor { get }
    var leftInset: CGFloat { get }
    var rightInset: CGFloat { get }
    var tabulationSpace: CGFloat { get }
    var insetBetweenImageAndText: CGFloat { get }
    var imageForUnorderedList: UIImage? { get }
    var sizeForUnorderedImage: CGSize { get }
}

///
class ListBlockNativeStyle: EJListBlockStyle {
    let font = UIFont.systemFont(ofSize: 18)
    let color = UIColor.black
    let leftInset: CGFloat = 0
    let rightInset: CGFloat = 0
    let lineSpacing: CGFloat = 4
    let tabulationSpace: CGFloat = 10
    let imageForUnorderedList = UIImage(named: "dot")
    let sizeForUnorderedImage = CGSize(width: 24, height: 24)
    let insetBetweenImageAndText: CGFloat = 0
}
