//
//  UIView+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/02.
//

import Foundation
import UIKit

extension UIView {
    
    /// 전체 화면 중 특정 영역까지 스크린 샷 생성하는 함수
    /// - Parameter maxHiehgt: 생성할 스크린샷 높이
    /// - Returns: 생성된 스크린샷
    func takeScreenShot(_ maxHiehgt: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: screenwidth, height: maxHiehgt), false, 0)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 그림자 생성하는 함수
    /// - Parameters:
    ///   - offset: 그림자 번짐 정도
    ///   - radius: 그림자 모서리 둥근 정도
    func createShadow(_ offset: CGSize, _ radius: CGFloat? = nil) {
        self.layer.shadowColor = UIColor.customBlackColor.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = radius ?? self.layer.cornerRadius
        self.layer.shadowOffset = offset
    }
    
    func findUserViewInit() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.subLightColor.withAlphaComponent(0.7)
    }
    
    func roundCorner(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
