//
//  UINavigationController+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/05.
//

import Foundation
import UIKit

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
