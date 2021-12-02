//
//  CalendarView+Style.swift
//  CalendarView
//
//  Created by Vitor Mesquita on 17/01/2018.
//  Copyright © 2018 Karmadust. All rights reserved.
//

import UIKit

extension CalendarView {
    
    public class Style {
        
        public static var Default: Style = Style()
        
        public init()
        {
        }
        
        
        //Header
        public var headerHeight: CGFloat     = 80.0
        public var headerTopMargin: CGFloat  = 5.0
        public var headerFont                = UIFont.systemFont(ofSize: 20) // Used for the month
        
        public var weekdaysTopMargin: CGFloat     = 5.0
        public var weekdaysBottomMargin: CGFloat  = 5.0
        public var weekdaysHeight: CGFloat        = 35.0
        
        //Common
        public var showAdjacentDays          = false
        
        //Default Style
        public var cellColorDefault          = UIColor.clear
        public var cellTextColorDefault      = UIColor.customBlackColor
        
        //Locale Style
        public var locale                    = Locale(identifier: "ko_KR")
        
        //Calendar Identifier Style
        public lazy var calendar: Calendar   = {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "KST")!
            return calendar
        }()
    }
}
