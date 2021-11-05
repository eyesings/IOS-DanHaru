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
    
    func saveFirstInstall(_ isFirst: Bool) {
        self.set(isFirst, forKey: Configs.UserDefaultsKey.isFirstInstall)
    }
}
