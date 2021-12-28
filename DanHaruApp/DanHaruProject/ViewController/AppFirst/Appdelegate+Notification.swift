//
//  Appdelegate+Notification.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/30.
//

import Foundation
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //앱이 실행중일때 iOS 10 이상부터
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let pushDic = notification.request.content.userInfo
        Dprint("userNotificationCenter push data = \(pushDic)")
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list])
        } else {
            completionHandler([.alert])
        }
        
        if let scheduleList = UserDefaults.notiScheduledData {
            let notificatoinID = notification.request.identifier
            let today = Date().dateToStr()
           
            for key in scheduleList.keys {
                if notificatoinID.contains("\(key)") && (scheduleList["\(key)"] as? String) == today {
                    center.getPendingNotificationRequests { pendingReqList in
                        for pendingReq in pendingReqList {
                            print("notiID \(notificatoinID) ,, dic key \(key)")
//                            if pendingReq.identifier.contains(notificatoinID) {
//                                print("need remove req \(pendingReq)")
//                                center.removePendingNotificationRequests(withIdentifiers: [notificatoinID])
//                                UserDefaults.standard.removeObject(forKey: "\(key)")
//                            }
                        }
                    }
                } else {
                    print("continue")
                }
            }
        }
    }

    //앱이 백그라운드에 있을때나 시작할때 실행중일때 모두 푸시를 터치하면 실행하는 메서드
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("userNotificationCenter didReceive")
        
        let actionId = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo
        
        func updateNotificationSchedule() {
            if let scheduleList = UserDefaults.notiScheduledData {
                let notificatoinID = response.notification.request.identifier
                let today = Date().dateToStr()
               
                for key in scheduleList.keys {
                    if notificatoinID.contains("\(key)") && (scheduleList["\(key)"] as? String) == today {
                        center.getPendingNotificationRequests { pendingReqList in
                            for pendingReq in pendingReqList {
                                print("notiID \(notificatoinID) ,, dic key \(key)")
                                if pendingReq.identifier.contains(notificatoinID) {
                                    print("need remove req \(pendingReq)")
                                    center.removePendingNotificationRequests(withIdentifiers: [notificatoinID])
                                    UserDefaults.standard.removeObject(forKey: "\(key)")
                                }
                            }
                        }
                    } else {
                        print("continue")
                    }
                }
            }
        }
        
        if actionId == UNNotificationDismissActionIdentifier {
            //메세지를 열지않고 지웠을때 호출된다.
            Dprint("UNNotificationDismissActionIdentifier")
            updateNotificationSchedule()
            completionHandler()
        }else if actionId == UNNotificationDefaultActionIdentifier {
            //푸시 메세지를 클릭했을때
            Dprint("UNNotificationDefaultActionIdentifier")
            updateNotificationSchedule()
            if let rootVC = RadHelper.getMainViewController() as? RadPushViewModelProtocol {
                _ = RadPushViewModel.init(WithPushInfo: userInfo as NSDictionary, delegate: rootVC)
            }else {
                Dprint("storyboard 못 불러옴")
            }
            completionHandler()
        }
        Dprint("actionId \(actionId)   userinfo  \(userInfo)")
    }
    
}
