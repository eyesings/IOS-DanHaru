//
//  UserDefault+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/05.
//

import Foundation


extension UserDefaults {
    
    static var isFirstInstall: Bool? {
        if let _ = self.standard.value(forKey: Configs.UserDefaultsKey.isFirstInstall) {
            return self.standard.bool(forKey: Configs.UserDefaultsKey.isFirstInstall)
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
        self.set(id, forKey: Configs.UserDefaultsKey.userInputID)
        self.set(pw, forKey: Configs.UserDefaultsKey.userInputPW)
    }
    
    func rmUserInputVal() {
        self.removeObject(forKey: Configs.UserDefaultsKey.userInputID)
        self.removeObject(forKey: Configs.UserDefaultsKey.userInputPW)
        UserModel = UserInfoModel()
    }
}
