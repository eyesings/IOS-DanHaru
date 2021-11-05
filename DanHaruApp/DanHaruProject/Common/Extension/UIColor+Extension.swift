//
//  UIColor+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/26.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 메인 색상
    static var mainColor = {
        return RadHelper.colorFromHex(hex: "D0C2C1")
    }()
    
    /// 메인 Base, 밝은 색상
    static var subLightColor = {
        return RadHelper.colorFromHex(hex: "EFE6E4")
    }()
    
    /// 메인 Base, 어두운 색상
    static var subHeavyColor = {
        return RadHelper.colorFromHex(hex: "9E9493")
    }()
    
    /// 기본 백그라운드 색상
    static var backgroundColor = {
        return RadHelper.colorFromHex(hex: "FFFCFC")
    }()
    
    /// 커스텀 블랙
    static var customBlackColor = {
        return RadHelper.colorFromHex(hex: "253138")
    }()
    
    /// 진한 회색
    static var heavyGrayColor = {
        return RadHelper.colorFromHex(hex: "6D7172")
    }()
    
    /// 밝은 회색
    static var lightGrayColor = {
        return RadHelper.colorFromHex(hex: "BCBEBF")
    }()
}
