//
//  PieChartView.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/02.
//

import Foundation
import UIKit
import SnapKit

struct Slice {
    var percent: CGFloat
    var color: UIColor
}

class PieChartView: UIView {
    
    private let animationDuration: CGFloat = 1
    private var sliceIndex: Int = 0
    private var currentPercent: CGFloat = 0.0
    
    var slices: [Slice]?
    
    // MARK: - Method
    // MARK: Public
    func animateChart() {
        sliceIndex = 0
        currentPercent = 0.0
        
        self.layer.sublayers = nil
        
        if slices != nil && slices!.count > 0 {
            let firstSlice = slices![0]
            addSlice(firstSlice)
        }
    }
    
    // MARK: Private
    private func addSlice(_ slice: Slice) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = getDuration(slice)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.delegate = self
        
        let canvasWidth = self.frame.width * 0.8
        let path = UIBezierPath(arcCenter: self.center,
                                radius: canvasWidth * 3 / 7.5,
                                startAngle: percentToRadian(currentPercent),
                                endAngle: percentToRadian(currentPercent + slice.percent),
                                clockwise: true)
        
        let sliceLayer = CAShapeLayer()
        sliceLayer.path = path.cgPath
        sliceLayer.fillColor = nil
        sliceLayer.strokeColor = slice.color.cgColor
        sliceLayer.lineWidth = canvasWidth * 2 / 10
        sliceLayer.strokeEnd = 1
        sliceLayer.add(animation, forKey: animation.keyPath)
        
        self.layer.addSublayer(sliceLayer)
    }
    
    private func percentToRadian(_ percent: CGFloat) -> CGFloat {
        var angle = 270 + percent * 360
        if angle >= 360 {
            angle -= 360
        }
        return angle * CGFloat.pi / 180.0
    }
    
    private func getDuration(_ slice: Slice) -> CFTimeInterval {
        return CFTimeInterval(slice.percent / 1.0 * animationDuration)
    }
}

extension PieChartView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            currentPercent += slices![sliceIndex].percent
            sliceIndex += 1
            if sliceIndex < slices!.count {
                let nextSlice = slices![sliceIndex]
                addSlice(nextSlice)
            }
        }
    }
}
