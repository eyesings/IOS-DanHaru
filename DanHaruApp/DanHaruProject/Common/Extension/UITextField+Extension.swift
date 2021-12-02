//
//  UITextField+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/27.
//

import Foundation
import UIKit

extension UITextField {
    
    /// 텍스트 필드 UI Custom
    /// - Parameters:
    ///   - h: UnderLine 높이
    ///   - padding: 들여쓰기 값
    func makesToCustomField(lineHeight h: CGFloat = 1.0, padding: CGFloat = 10.0, customWidth: CGFloat = screenwidth*0.8) {
        
        guard self.frame.height > 0.0 else { return }
        
        self.borderStyle = .none
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - h, width: customWidth, height: h)
        border.borderWidth = h
        border.backgroundColor = UIColor.heavyGrayColor.cgColor
        self.layer.addSublayer(border)
        
        let paddingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /// 텍스트 필드 UI 업데이트
    /// - Parameter isNeedClear: 색상 초기화 필요 여부
    func updateUI(_ isNeedClear: Bool = false) {
        
        if let borderLayer = self.layer.sublayers?.first {
            borderLayer.borderColor = self.hasText == false ? UIColor.red.cgColor : UIColor.heavyGrayColor.cgColor
            borderLayer.borderColor = isNeedClear ? UIColor.heavyGrayColor.cgColor : borderLayer.borderColor
        }
        
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
    
    /// 이메일 텍스트 필드 값 없을 때 UI 변경 함수
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
    
    /// 이메일 정규식 표현
    /// - Returns: 이메일 정규식 여부
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }
    
    /// 입력 값 존재 시 Placeholder  색상
    static var hasTextPlaceholderColorAttr: [NSAttributedString.Key : Any ] = {
        return [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
    }()
    
    /// 입력 값 미존재 시 Placeholder  색상
    static var noneHasTextPlaceholderColorAttr: [NSAttributedString.Key : Any ] = {
        return [NSAttributedString.Key.foregroundColor : UIColor.red]
    }()
}
