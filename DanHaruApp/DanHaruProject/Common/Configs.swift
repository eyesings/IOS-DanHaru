//
//  Configs.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/28.
//

import Foundation
import UIKit

class StoryBoardRef {
    static let loginVC = "LOGIN_VC"
    static let joinVC  = "JOIN_VC"
    static let findVC  = "INFO_FIND_VC"
}

enum InputType: Int {
    case email = 101
    case id = 102
    case pw = 103
    case done
}

struct Configs {
    
    static var formatter = DateFormatter()
    /*
    static var todoListCellBackGroundColor: [UIColor] = [
        UIColor(red: 160/255, green: 231/255, blue: 229/255, alpha: 1.0),
        UIColor(red: 180/255, green: 248/255, blue: 200/255, alpha: 1.0),
        UIColor(red: 251/255, green: 231/255, blue: 198/255, alpha: 1.0),
        UIColor(red: 255/255, green: 174/255, blue: 188/255, alpha: 1.0)
    ]
    */
}


