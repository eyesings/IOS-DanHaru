//
//  DateFormatter+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2022/01/11.
//

import Foundation


extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale(identifier: "ko_KR")
        timeZone = TimeZone(abbreviation: "KST")
    }
}
