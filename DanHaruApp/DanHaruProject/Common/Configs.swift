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
