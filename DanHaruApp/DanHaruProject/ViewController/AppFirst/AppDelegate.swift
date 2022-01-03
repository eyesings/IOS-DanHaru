//
//  AppDelegate.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseDynamicLinks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var splashView: SplashView!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //다크모드 막기
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        if UserDefaults.isFirstInstall != false {
            self.switchToHome()
            UserDefaults.standard.saveFirstInstall(false)
        }
        
        guard let rootVc = self.window?.rootViewController else { return false }
        
        if !RadReachability.isConnectedToNetwork() {
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.Network.networkErr,
                                                            message: RadMessage.Network.networkErrMsg,
                                                            isNeedCancel: false,
                                                            viewController: rootVc) {
                if ($0) { exit(0) }
            }
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        splashView = SplashView.init(frame: rootVc.view.frame)
        rootVc.view.addSubview(splashView)
        
        registeredForRemoteNotifications(application: application)
        
        // Local Notification Observal 등록
        let category = UNNotificationCategory(identifier: "dismissCategoryID", actions: [], intentIdentifiers: [], options: .customDismissAction)
        var setCategory = Set<UNNotificationCategory>()
        setCategory.insert(category)
        UNUserNotificationCenter.current().setNotificationCategories(setCategory)
        
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Configs.NotificationName.didEnterBackground, object: nil, userInfo: nil)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let webUrl = userActivity.webpageURL
        else { print("can not convert to url \(String(describing: userActivity.webpageURL))"); return true }
        
        //firebase dynamicLink
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(webUrl) { (dynamiclink, error) in
            
            if let openLink = dynamiclink?.url {
                print("openLink:::\(openLink)")
                if openLink.absoluteString.contains(Configs.URL.inviteChall),
                   let linkQuery = openLink.query {
                    
                    var queryDic: [String:Any] = [:]
                    for (_, arr) in linkQuery.components(separatedBy: "&").enumerated() {
                        if arr.contains("custid="),
                           let custId = arr.components(separatedBy: "custid=").last {
                            queryDic["custid"] = custId
                        } else if arr.contains("todoidx="),
                                  let todoidx = arr.components(separatedBy: "todoidx=").last {
                            queryDic["todoidx"] = todoidx
                        }
                    }
                    
                    NotificationCenter.default.post(name: Configs.NotificationName.inviteFriendChall, object: queryDic)
                }
            }
        }
        
        return handled
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("url! \(url.absoluteString)")
        return true
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
            UserDefaults.standard.initUserPushSetting(granted)
            
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
        
        Messaging.messaging().apnsToken = deviceToken
        
        print("messaging fcm token \(Messaging.messaging().fcmToken)")
    }
}



extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Dprint("didReceiveRegistrationToken")
    }
}
