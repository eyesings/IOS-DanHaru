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
    
    static var todoLightBlueColor = {
        return RadHelper.colorFromHex(hex: "A0E7E5")
    }()
    
    static var todoLightGreenColor = {
        return RadHelper.colorFromHex(hex: "B4F8C8")
    }()
    
    static var todoLightYellowColor = {
        return RadHelper.colorFromHex(hex: "FBE7C6")
    }()
    
    static var todoHotPickColor = {
        return RadHelper.colorFromHex(hex: "FFAEBC")
    }()
    
    func generateRandomBackgroundColor() -> UIColor {
        let randomColorGenerator = { () -> CGFloat in
            CGFloat(arc4random() % 256) / 256
        }
        
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
        
        let mixRed: CGFloat = 1+0xad/256
        let mixGreen: CGFloat = 1+0xd8/256
        let mixBlue: CGFloat = 1+0xe6/256
        
        red = (red + mixRed) / 3
        green = (green + mixGreen) / 3
        blue = (blue + mixBlue) / 3
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
}
