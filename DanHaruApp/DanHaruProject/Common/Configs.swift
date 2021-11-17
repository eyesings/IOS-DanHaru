//
//  Configs.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/28.
//

import Foundation
import UIKit

/// 스토리보드 ID 모음
struct StoryBoardRef {
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
    static let askVC             = "ASK_VC"
}

/// CollectionView ID 모음
struct CollectionViewID {
    static let doing = "doingCell"
    static let done = "doneCell"
    static let fail = "failCell"
    
    static func getIdByTag(_ tag: CollectionViewTag) -> String {
        if tag == .doing {
            return CollectionViewID.doing
        } else if tag == .fail {
            return CollectionViewID.fail
        } else if tag == .done {
            return CollectionViewID.done
        } else {
            return ""
        }
    }
}

/// 입력 받는 값
enum InputType: Int {
    case email = 101
    case id = 102
    case pw = 103
    case nickName = 104
    case introduce = 105
    case done
    
    func name() -> String {
        switch self {
        case .email: return "이메일"
        case .id: return "아이디"
        case .pw: return "비밀번호"
        case .nickName: return "닉네임"
        case .introduce: return "한줄 소개글"
        case .done: return ""
        }
    }
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

/// 컬렉션 뷰 태그 값
enum CollectionViewTag: Int {
    case doing = 400
    case fail  = 401
    case done  = 402
    case none  = 403
}

/// API 통신 결과 코드
enum APIResultCode: String {
    case success = "0000"
    case failure = "9999"

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
    
    struct NotificationName {
        static let userLoginSuccess = Notification.Name(rawValue: "USER_LOGIN_SUCCESS")
    }
    
    struct API {
        static let host       = "http://10.23.81.103:8080/api"
        static let checkValid = host + "/auth/validation/member/"
        static let validEmail = checkValid + "email"
        static let validID    = checkValid + "id"
        static let join       = host + "/auth/register/member/email"
        static let login      = host + "/auth/login/member/email"
    }
    
}

var UserModel: UserInfoModel = UserInfoModel()
var keyboardH: CGFloat = 0
