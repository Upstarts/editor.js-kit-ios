//
//  NSAttributedString+Ext.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import UIKit

///
extension NSAttributedString {
    
    /**
     */
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /**
     */
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
    
    /**
     */
    func replacing(with substrings: [String: [NSAttributedString]]) -> NSMutableAttributedString {
        let mutableCopy = NSMutableAttributedString(attributedString: self)
        for (pattern, strings) in substrings {
            let scanner = Scanner(string: self.string)
            var stringsCouter = 0
            while !scanner.isAtEnd && stringsCouter < strings.count  {
                scanner.scanUpTo("%", into: nil)
                if scanner.scanString(pattern, into: nil) {
                    mutableCopy.replaceCharacters(in: NSRange(location: scanner.scanLocation-2, length: 2),
                                                  with: strings[stringsCouter])
                    stringsCouter += 1
                }
            }
        }
        return mutableCopy
    }
}

///
extension NSAttributedString {
    
    /**
     */
    func labelHeight(boundingWidth: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = self
        let height = label.sizeThatFits(CGSize(width: boundingWidth, height: 0)).height
        return height
    }
    
    /**
     */
    func textViewHeight(boundingWidth: CGFloat) -> CGFloat {
        let textView = UITextViewFixed(frame: CGRect(origin: .zero, size: CGSize(width: boundingWidth, height: 0)))
        textView.attributedText = self
        textView.setup()
        let size = textView.sizeThatFits(CGSize(width: boundingWidth, height: 0))
        return size.height
    }
}

/// Convenience initializers
extension NSAttributedString {
    
    /**
     */
    convenience init(htmlString html: String,
                     font: UIFont? = nil,
                     useDocumentFontSize: Bool = false,
                     forceFontFace: Bool = false) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard let htmlData = data,
            let font = font,
            let attr = try? NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = useDocumentFontSize ? nil : font.pointSize
        let fontFace: String? = forceFontFace ? (font.fontDescriptor.object(forKey: .face) as? String ?? nil) : nil
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var fontDesc = htmlFont.fontDescriptor.withFamily(font.familyName)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0,
                    let updatedDesc = fontDesc.withSymbolicTraits(.traitBold) {
                    fontDesc = updatedDesc
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0,
                    let updatedDesc = fontDesc.withSymbolicTraits(.traitItalic) {
                    fontDesc = updatedDesc
                }
                
                if forceFontFace, let fontFace = fontFace {
                    fontDesc = fontDesc.withFace(fontFace)
                }

                attr.addAttribute(.font, value: UIFont(descriptor: fontDesc, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }

        self.init(attributedString: attr)
    }
}
