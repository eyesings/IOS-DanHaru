//
//  Configs.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/28.
//

import Foundation
import UIKit

/// 스토리보드 ID 모음
class StoryBoardRef {
    // Home
    static let homeVC  = "HOME_VC"
    
    // Main
    static let mainVC  = "MAIN_VC"
    static let mainNavVC = "MAIN_NAV_VC"
    
    // Login & Join
    static let loginVC = "LOGIN_VC"
    static let joinVC  = "JOIN_VC"
    static let findVC  = "INFO_FIND_VC"
    
    // MyPage
    static let myPageVC          = "MY_PAGE_VC"
    static let profileVC         = "PROFIE_VC"
    static let noneLoginMyPageVC = "MY_PAGE_NONE_LOGIN"
    static let settingVC         = "SETTING_VC"
    static let myChallangeVC     = "CHALLENGE_VC"
}

/// 입력 받는 값
enum InputType: Int {
    case email = 101
    case id = 102
    case pw = 103
    case nickName = 104
    case introduce = 105
    case done
}

/// 도전 전체보기 토글 버튼 태그 값
enum MyChallangeBtnTag: Int {
    case todoList = 200
    case myChallange = 201
}

/// 툴 바 버튼 태그 값
enum ToolBarBtnTag: Int, CaseIterable {
    case home   = 300
    case myPage = 301
}

/// 바텀 뷰 재사용 코드
enum BottomViewCheck: String {
    case todoAdd = "todoAdd"
    case startDate = "startDate"
    case endDate = "endDate"
    case cycleTime = "cycleTime"
    case audioRecode = "audioRecode"
}

enum DateLabelTag: Int {
    case startDateLabel = 1111
    case endDateLabel = 2222
}

enum DayBtnTag: Int {
    case monday = 111
    case tuesday = 222
    case wednesday = 333
    case thursday = 444
    case friday = 555
    case saturday = 666
    case sunday = 777
    case everyday = 888
}

enum ImageDeleteBtnTag: Int {
    case deleteImageView1 = 121
    case deleteImageView2 = 122
    case deleteImageView3 = 123
}

struct Configs {
    
    static var formatter = DateFormatter()
    
    struct UserDefaultsKey {
        static let isFirstInstall = "IS_FIRST_INSTALL"
    }
    
}

var UserModel: UserInfoModel = UserInfoModel()
