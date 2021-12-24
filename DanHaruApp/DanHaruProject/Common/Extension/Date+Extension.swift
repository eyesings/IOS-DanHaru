//
//  Date+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/29.
//

import Foundation

extension DateFormatter {
    
    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale(identifier: "ko_KR")
        timeZone = TimeZone(abbreviation: "KST")
    }
    
    func korDateString(date: Date = Date(), dateFormatter format: String = RadMessage.DateFormattor.apiParamType) -> String {
        return DateFormatter(format: format).string(from: date)
    }
}

extension Date {
    func dateToStr(format: String = RadMessage.DateFormattor.apiParamType) -> String {
        return DateFormatter(format: format).string(from: self)
    }
    
    func convertToTimeZone(from fromTimeZone: TimeZone, to toTimeZone: TimeZone) -> Date {
         let delta = TimeInterval(toTimeZone.secondsFromGMT(for: self) - fromTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
    
    var timestamp: Int64 {
        Int64(Date().timeIntervalSince1970 * 1000)
    }
}
