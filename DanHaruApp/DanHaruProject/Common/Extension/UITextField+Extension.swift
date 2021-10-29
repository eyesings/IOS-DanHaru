//
//  UITextField+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/27.
//

import Foundation
import UIKit

extension UITextField {
    func makesToCustomField(lineHeight h: CGFloat = 1.0, padding: CGFloat = 10.0) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        border.borderWidth = h
        border.backgroundColor = UIColor.heavyGrayColor.cgColor
        self.layer.addSublayer(border)
        
        let paddingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func changeFieldUnderLineColor(_ isNeedClear: Bool = false) {
        if let borderLayer = self.layer.sublayers?.first {
            borderLayer.borderColor = self.hasText == false ? UIColor.red.cgColor : UIColor.heavyGrayColor.cgColor
            borderLayer.borderColor = isNeedClear ? UIColor.heavyGrayColor.cgColor : borderLayer.borderColor
        }
    }
    
    func updateUI(_ isNeedClear: Bool = false) {
        self.changeFieldUnderLineColor(isNeedClear)
        
        if let placeholderStr = self.placeholder {
            let nonHasPlaceholderAttr: NSAttributedString = {
                return NSAttributedString(string: placeholderStr, attributes: UITextField.noneHasTextPlaceholderColorAttr)
            }()
            let hasPlaceholderAttr: NSAttributedString = {
                return NSAttributedString(string: placeholderStr, attributes: UITextField.hasTextPlaceholderColorAttr)
            }()
            
            self.attributedPlaceholder = isNeedClear ? hasPlaceholderAttr : ( self.hasText == false ? nonHasPlaceholderAttr : hasPlaceholderAttr )
        }
        
        self.layoutIfNeeded()
    }
    
    func fieldNotHasTextUI() {
        if self.isValidEmail() == false {
            if let borderLayer = self.layer.sublayers?.first {
                borderLayer.borderColor = UIColor.red.cgColor
            }
            
            if let placeholderStr = self.placeholder {
                let nonHasPlaceholderAttr: NSAttributedString = {
                    return NSAttributedString(string: placeholderStr, attributes: UITextField.noneHasTextPlaceholderColorAttr)
                }()
                
                self.attributedPlaceholder = nonHasPlaceholderAttr
            }
            
            self.layoutIfNeeded()
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }
    
    
    static var hasTextPlaceholderColorAttr: [NSAttributedString.Key : Any ] = {
        return [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
    }()
    
    static var noneHasTextPlaceholderColorAttr: [NSAttributedString.Key : Any ] = {
        return [NSAttributedString.Key.foregroundColor : UIColor.red]
    }()
}
