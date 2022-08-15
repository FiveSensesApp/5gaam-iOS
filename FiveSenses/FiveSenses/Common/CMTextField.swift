//
//  CMTextField.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/15.
//

import UIKit

class CMTextField: UITextField {
    var insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
    convenience init(isPlaceHolderBold: Bool, placeHolder: String, font: UIFont, inset: UIEdgeInsets) {
        self.init()
        
        self.insets = inset
        self.font = font
        
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        
        if isPlaceHolderBold {
            self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.font: UIFont.bold(font.pointSize)])
        } else {
            self.placeholder = placeHolder
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    // clearButton의 위치와 크기를 고려해 inset을 삽입
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: insets.top,
            left: insets.left,
            bottom: insets.bottom,
            right: clearButtonWidth + clearButtonOffset + clearButtonLeftPadding
        )
        
        return bounds.inset(by: editingInsets)
    }
    
    // clearButtonOffset만큼 x축 이동
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset
        return clearButtonRect
    }
}
