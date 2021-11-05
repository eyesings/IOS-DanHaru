//
//  AppDelegate.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //다크모드 막기
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        if UserDefaults.isFirstInstall != false {
            self.switchToHome()
            UserDefaults.standard.saveFirstInstall(false)
        }
        
        return true
    }
    
    // MARK: RootVC SwitchMethod
    func switchToHome(needMovePageRef: String = "") {
        if let homeVC = RadHelper.getVCFromHomeSB() as? HomeViewController {
            homeVC.needMovePageID = needMovePageRef
            let nav = UINavigationController(rootViewController: homeVC)
            nav.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
    }
    
    func switchToMain() {
        if let mainVC = RadHelper.getVCFromMainSB() as? UINavigationController {
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        }
    }

}

