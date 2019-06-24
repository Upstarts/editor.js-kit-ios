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

///
extension String {
    private static let pattern = "<html><head><style type='text/css'>body {font-family: \"%@\";font-size: %dpx;}b {font-family: \"%@\";font-size: %dpx;}</style></head><body>%@</body></html>"
    
    /**
     */
    func convertHTML(font: UIFont) -> NSAttributedString? {
        let formattedHTMLText = String(format: .pattern, font.familyName, Int(font.pointSize), font.familyName, Int(font.pointSize), self)
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        
        let attributedString = try? NSAttributedString(
            data: formattedHTMLText.data(using: String.Encoding(rawValue: String.Encoding.unicode.rawValue), allowLossyConversion: true)!,
            options: options,
            documentAttributes: nil)
        
        
        return attributedString
    }
}
