//
//  UserDefault+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/05.
//

import Foundation


extension UserDefaults {
    
    static var isFirstInstall: Bool? {
        if let _ = self.standard.value(forKey: Configs.UserDefaultsKey.isFirstInstall),
           let _ = self.standard.value(forKey: Configs.UserDefaultsKey.userInputID),
           let _ = self.standard.value(forKey: Configs.UserDefaultsKey.userInputPW) {
            return self.standard.bool(forKey: Configs.UserDefaultsKey.isFirstInstall)
        } else {
            return nil
        }
    }
    
    /// 유저 푸시 값 호출
    static var userPushSetting: Bool? {
        if let _ = self.standard.value(forKey: Configs.UserDefaultsKey.pushEnable) {
            return self.standard.bool(forKey: Configs.UserDefaultsKey.pushEnable)
        } else {
            return nil
        }
    }
    
    static var userInputId: String {
        return RadHelper.AES256Decrypt(WithValue: self.standard.string(forKey: Configs.UserDefaultsKey.userInputID))
    }
    
    static var userInputPw: String {
        return RadHelper.AES256Decrypt(WithValue: self.standard.string(forKey: Configs.UserDefaultsKey.userInputPW))
    }
    
    func saveFirstInstall(_ isFirst: Bool) {
        self.set(isFirst, forKey: Configs.UserDefaultsKey.isFirstInstall)
    }
    
    func saveUserInputVal(id: String, pw: String) {
        self.set(RadHelper.AES256Encrypt(WithValue: id), forKey: Configs.UserDefaultsKey.userInputID)
        self.set(RadHelper.AES256Encrypt(WithValue: pw), forKey: Configs.UserDefaultsKey.userInputPW)
    }
    
    /// 유저 푸시 저장
    /// - Parameter isOn: Push Allow / Disallow
    func saveUserPushSetting(_ isOn: Bool) {
        self.set(isOn, forKey: Configs.UserDefaultsKey.pushEnable)
    }
    
    func initUserPushSetting(_ isOn: Bool) {
        guard let _ = UserDefaults.userPushSetting else {
            self.saveUserPushSetting(isOn)
            return
        }
    }
    
    func rmUserInputVal() {
        self.removeObject(forKey: Configs.UserDefaultsKey.userInputID)
        self.removeObject(forKey: Configs.UserDefaultsKey.userInputPW)
        UserModel = UserInfoModel()
    }
    
    
    
    // MARK: Local Notification Data
    static var notiScheduledData: [String:Any]? {
        return self.standard.value(forKey: Configs.UserDefaultsKey.pushPendingDic) as? [String:Any]
    }
    
    func updateNotiSchedule(endDate ed: String, notiID id: String) {
        guard let localSchedule = UserDefaults.notiScheduledData
        else { self.set([id:ed], forKey: Configs.UserDefaultsKey.pushPendingDic); return }
        
        var updateSchedule = localSchedule
        updateSchedule.updateValue(ed, forKey: id)
        
        self.set(updateSchedule, forKey: Configs.UserDefaultsKey.pushPendingDic)
        
        print("UserDefaults.notiScheduledData \(UserDefaults.notiScheduledData)")
    }
    
    func removeWithKey(key: String) {
        guard var localSchedule = UserDefaults.notiScheduledData
        else { return }
        
        localSchedule.removeValue(forKey: key)
        
        self.set(localSchedule, forKey: Configs.UserDefaultsKey.pushPendingDic)
        
        print("UserDefaults.removeSchedule \(UserDefaults.notiScheduledData)")
    }
}
