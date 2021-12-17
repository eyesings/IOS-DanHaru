//
//  UINavigationController+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/05.
//

import Foundation
import UIKit
import Lottie

extension UINavigationController {
    
    /// VC Push With ToolBar Hidden
    /// - Parameter vc: push viewcontroller
    func pushViewController(_ vc: UIViewController) {
        self.pushViewController(vc, animated: true)
        self.setToolbarHidden(true, animated: false)
    }
    
    /// VC Pop With ToolBar Show
    func popViewController() {
        self.popViewController(animated: true)
        self.setToolbarHidden(false, animated: false)
    }
    
    func popToMainViewController() {
        self.setToolbarHidden(false, animated: true)
        self.popToRootViewController(animated: true)
    }
}


extension UIViewController {
    
    func showLoadingView() {
        
        let animateView = self.view.subviews.compactMap { $0 as? AnimationView }
        if animateView.isEmpty == false { return }
        
        let loadingView = AnimationView(name: "loading")
        loadingView.loopMode = .loop
        loadingView.play()
        loadingView.backgroundColor = UIColor.mainColor.withAlphaComponent(0.1)
        loadingView.layer.cornerRadius = 10
        self.view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { view in
            view.centerY.centerX.equalTo(self.view)
            view.width.equalTo(self.view).multipliedBy(0.3)
            view.height.equalTo(loadingView.snp.width)
        }
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            for subview in self.view.subviews {
                if let loadingView = subview as? AnimationView {
                    loadingView.stop()
                    loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    func safeAreaView(_ color: UIColor = .subHeavyColor, topConst const: UIView) {
        let safeAreaView = UIView(frame: .zero)
        safeAreaView.backgroundColor = color
        self.view.addSubview(safeAreaView)
        safeAreaView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalTo(self.view)
            make.top.equalTo(const.snp.bottom)
        }
    }
}
