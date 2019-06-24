//
//  String+Ext.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import UIKit

///
extension String {
    
    /**
     */
    func height(using font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return size.height
    }
    
    /**
     */
    func size(using font: UIFont, boundingWidth: CGFloat, boundingHeight: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let boundingSize = CGSize(width: boundingWidth, height: boundingHeight)
        let boundingRect = self.boundingRect(with: boundingSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil)
        return boundingRect.size
    }
    
    /**
     */
    func convertedToLowercasedLatin() -> String? {
        return self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false)
    }
    
    /**
     */
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
