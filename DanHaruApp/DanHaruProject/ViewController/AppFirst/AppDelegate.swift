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
        
        if !RadReachability.isConnectedToNetwork() {
            RadHelper.getRootViewController()?.showNetworkErrorView()
        }
        
        registeredForRemoteNotifications(application: application)
        
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

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Configs.NotificationName.audioRecordContinue, object: nil, userInfo: nil)
    }
 
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: Configs.NotificationName.audioRecordRemove, object: nil, userInfo: nil)
    }
    
    /// Notifications 등록
    /// - Parameter application: UIApplication
    func registeredForRemoteNotifications(application: UIApplication) {
        #if !TARGET_IPHONE_SIMULATOR
        //푸시 등록
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            
            Dprint("granted  \(granted)")
            
            
            if error != nil {
                //error 발생시
                Dprint("push register error \(String(describing: error?.localizedDescription))")
            }else if granted {
                Dprint("push register agreement !!!!!")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }else {
                //거부시
                Dprint("push regiser denied  @!!!!!!")
            }
        }
        #endif
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("deviceToKenString \(deviceTokenString)")
    }
}

