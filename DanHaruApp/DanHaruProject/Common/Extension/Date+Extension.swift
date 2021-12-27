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

extension Calendar {
    func makesTimeToString() -> String {
        var hour = self.component(.hour, from: Date())
        let minute = self.component(.minute, from: Date()).roundedUp()
        
        if minute == 60 {
            hour += 1
        }
        
        return "\(hour) : " + (minute == 60 ? "00" : "\(minute)")
    }
}


extension Int {
    func roundedUp() -> Int {
        let doubleVal = Double(self)
        let makesDecimal = doubleVal / 10
        let roundUp  = makesDecimal.rounded(.up) * 10
        
        return Int(roundUp)
    }
}
