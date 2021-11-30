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
    
    func snapshot() -> UIView {
        if let contents = layer.contents {
            var snapshotedView: UIView!
            
            if let view = self as? UIImageView {
                snapshotedView = type(of: view).init(image: view.image)
                snapshotedView.bounds = view.bounds
            } else {
                snapshotedView = UIView(frame: frame)
                snapshotedView.layer.contents = contents
                snapshotedView.layer.bounds = layer.bounds
            }
            snapshotedView.layer.cornerRadius = layer.cornerRadius
            snapshotedView.layer.masksToBounds = layer.masksToBounds
            snapshotedView.contentMode = contentMode
            snapshotedView.transform = transform
            
            return snapshotedView
        } else {
            return snapshotView(afterScreenUpdates: true)!
        }
    }
    
    
    enum ViewSide: String {
            case Left = "Left", Right = "Right", Top = "Top", Bottom = "Bottom"
        }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.borderColor = color
        border.name = side.rawValue
        switch side {
        case .Left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .Right: border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        case .Top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .Bottom: border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        }
        
        border.borderWidth = thickness
        
        layer.addSublayer(border)
    }
    
    func removeBorder(toSide side: ViewSide) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == side.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
    
}
