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
    
    static var mainBackgroundColor = UIColor(red: 255/255, green: 252/255, blue: 252/255, alpha: 1.0)
    
    // 좀더 고민
    enum todoListColor {
        case tiffanyBlue
        case mint
        case yellow
        case hotPink
    }
    
    static var todoListCellBackGroundColor: [UIColor] = [
        UIColor(red: 160/255, green: 231/255, blue: 229/255, alpha: 1.0),
        UIColor(red: 180/255, green: 248/255, blue: 200/255, alpha: 1.0),
        UIColor(red: 251/255, green: 231/255, blue: 198/255, alpha: 1.0),
        UIColor(red: 255/255, green: 174/255, blue: 188/255, alpha: 1.0)
    ]
    
}


extension Configs.todoListColor {
    var value: UIColor {
        get {
            switch self {
            case .tiffanyBlue:
                return UIColor(red: 160/255, green: 231/255, blue: 229/255, alpha: 1.0)
            case .mint:
                return UIColor(red: 180/255, green: 248/255, blue: 200/255, alpha: 1.0)
            case .yellow:
                return UIColor(red: 251/255, green: 231/255, blue: 198/255, alpha: 1.0)
            case .hotPink:
                return UIColor(red: 255/255, green: 174/255, blue: 188/255, alpha: 1.0)
            }
        }
    }
}
