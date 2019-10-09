//
//  UITextView+Fixed.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 09/10/2019.
//

import UIKit

///
public class UITextViewFixed: UITextView {
    
    /**
     */
    override public func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    /**
     */
    public func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
