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
    func labelHeight(boundingWidth: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = self
        let height = label.sizeThatFits(CGSize(width: boundingWidth, height: 0)).height
        return height
    }
    
    func textViewHeight(boundingWidth: CGFloat) -> CGFloat {
        let textView = UITextViewFixed(frame: CGRect(origin: .zero, size: CGSize(width: boundingWidth, height: 0)))
        textView.attributedText = self
        textView.setup()
        let size = textView.sizeThatFits(CGSize(width: boundingWidth, height: 0))
        return size.height
    }
}
