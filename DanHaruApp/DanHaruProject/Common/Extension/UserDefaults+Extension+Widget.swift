//
//  UserDefaults+Extension+Widget.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2022/01/11.
//

import Foundation


extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.danharu"
        return UserDefaults(suiteName: appGroupId)!
    }
}
