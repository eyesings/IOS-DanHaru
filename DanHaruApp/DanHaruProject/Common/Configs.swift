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
    static let askDetailVC       = "ASK_DETAIL_VC"
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
    case id
    case pw
    case nickName
    case introduce
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
    case myChallange
    
    func name() -> String {
        switch self {
        case .todoList: return "할 일"
        case .myChallange: return "도전"
        }
    }
}

/// 툴 바 버튼 태그 값
enum ToolBarBtnTag: Int, CaseIterable {
    case home   = 300
    case myPage
}

/// 컬렉션 뷰 태그 값
enum CollectionViewTag: Int {
    case doing = 400
    case fail
    case done
    case none
    
    func name() -> String {
        switch self {
        case .doing: return "진행 중인"
        case .fail: return "완료 된"
        case .done: return "미완료 된"
        case .none: return ""
        }
    }
}

/// 디테일 푸시 버튼 태그 값
enum DetailNotiDayBtnTag: Int {
    case sunday = 500
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case everyday
    case none //디폴트가 everyday로 되어 있어서 수정할 때마다 매일 버튼 활성화, 선택안했다는 값 추가로 수정
    
    func name() -> String {
        switch self {
        case .sunday: return "일"
        case .monday: return "월"
        case .tuesday: return "화"
        case .wednesday: return "수"
        case .thursday: return "목"
        case .friday: return "금"
        case .saturday: return "토"
        case .everyday: return "매일"
        case .none: return "없음"
        }
    }
    
    func calendarWeekVal() -> Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .everyday: return 8
        case .none: return 0
        }
    }
    
    static func nameToSelf(val: String) -> Self {
        switch val {
        case "일": return .sunday
        case "월": return .monday
        case "화": return .tuesday
        case "수": return .wednesday
        case "목": return .thursday
        case "금": return .friday
        case "토": return .saturday
        case "매일": return .everyday
        default : return .none
        }
    }
}

enum DetailCollectionViewTag: Int {
    case currAuth = 600
    case imgAuth
}

enum DetailAuthBtnTag: Int {
    case image = 700
    case audio
    case check
}

enum TodoChallStatus: String {
    case doing = "001"
    case fail = "002"
    case done = "003"
}

/// API 통신 결과 코드
enum APIResultCode: String {
    case success = "0000"
    case failure = "9999"
}

/// 가져올 Image Data Type
enum ImageInfo {
    case url
    case name
}

/// 마이페이지 - 현황 데이터 타입
enum UserTodoType {
    case todo
    case challenge
    case done
}

/// 통신하는 API 타입
enum APIType {
    case UserJoin
    case UserLogin
    case UserValidate
    case UserUpdate
    case UserProfileImg
    case UserTodoCnt
    case UserAllTodoList
    case TodoList
    case TodoCreate
    case TodoDetail
    case TodoUpdate
    case TodoDelete
    case TodoCreateChallenge
    case TodoDeleteChallenge
    case TodoCreateCertification
    case NetworkNotConnected
}

/// 바텀 뷰 재사용 코드
enum BottomViewCheck: String {
    case todoAdd = "todoAdd"
    case startDate = "startDate"
    case endDate = "endDate"
    case cycleTime = "cycleTime"
    case audioRecord = "audioRecode"
    
    func bottomBtnName() -> String {
        switch self {
        case .todoAdd: return "등록하기"
        case .startDate, .endDate, .cycleTime, .audioRecord: return "확인"
        }
    }
}

enum DateLabelTag: Int {
    case startDateLabel = 1111
    case endDateLabel = 2222
}


struct Configs {
    
    static let BASE64Key = "DanHaruoMJVisBbDHcRBJogBtryYmhuk"
    static let dynamicPrefix = "https://danharuproject.page.link/"
    static let appstoreID = "1600367875"
    static let appStoreAddress = "https://itunes.apple.com/app/\(appstoreID)"
    
    struct UserDefaultsKey {
        static let isFirstInstall = "IS_FIRST_INSTALL"
        static let userInputID    = "USER_INPUT_ID"
        static let userInputPW    = "USER_INPUT_PW"
        static let pushEnable     = "PUSH_ENABLE"
        static let pushPendingDic = "PUSH_PENDING_DIC"
        static let listForWidget  = "TODO_LIST_FOR_WIDGET"
        static let authForWidget  = "AUTH_FOR_WIDGET"
    }
    
    struct NotificationName {
        static let userLoginSuccess    = Notification.Name(rawValue: "USER_LOGIN_SUCCESS")
        static let todoListFetchDone   = Notification.Name(rawValue: "TODO_LIST_FETCH_DONE")
        static let todoListCreateNew   = Notification.Name(rawValue: "TODO_LIST_CREATE_NEW")
        static let inviteFriendChall   = Notification.Name(rawValue: "INVITE_FRIEND_CHALL")
        static let openAppFromWidget   = Notification.Name(rawValue: "OPEN_APP_FROM_WIDGET")
        static let reloadAfterLogout   = Notification.Name(rawValue: "RELOAD_AFTER_LOGOUT")
        static let audioRecordContinue = Notification.Name(rawValue: "AUDIO_RECORD_CONTINUE")
        static let audioRecordRemove   = Notification.Name(rawValue: "AUDIO_RECORD_REMOVE")
        static let networkRetryConnect = Notification.Name(rawValue: "NETWORK_RETRY_CONNECT")
        static let didEnterBackground  = Notification.Name(rawValue: "DID_ENTER_BACKGROUND")
    }
    
    struct API {
#if DEBUG
        //http://10.23.81.63:8080/
        static let host       = "http://api-danharu-dev-api.ap-northeast-2.elasticbeanstalk.com/api"
#else
        static let host       = "http://api-danharu-dev-api.ap-northeast-2.elasticbeanstalk.com/api"
#endif
        static let checkValid = host + "/auth/validation/member/"
        static let validEmail = checkValid + "email"
        static let validID    = checkValid + "id"
        static let join       = host + "/auth/register/member/email"
        static let login      = host + "/auth/login/member/email"
        // MyPage
        static let updateUser = host + "/mypage/update"
        static let getUsrImg  = host + "/mypage/getImages"
        static let getUsrTodo = host + "/mypage/list"
        static let getUsrAll  = host + "/mypage/total/list"
        // SearchList
        static let todoList   = host + "/todo/main/list"
        static let createTodo = host + "/todo/main/create"
        static let todoDelete = host + "/todo/main/delete"
        // Detail
        static let todoDetail = host + "/todo/detail/list"
        static let updateDtl  = host + "/todo/detail/update"
        static let getCertiImg = host + "/todo/detail/getFile"
        // Detail - Challenge
        static let createChl  = host + "/todo/challenge/create"
        static let deleteChl  = host + "/todo/challenge/delete"
        // Detail - Certificate
        static let createCerti = host + "/todo/certification/create"
        static let certiList  = host + "/todo/certification/list"
        // Detail - Push
        static let subjectTkn = host + "/todo/detail/subject/token"
        static let sendMsg    = host + "/todo/detail/subject/send/push"
        static let deleteTkn  = host + "/todo/detail/subject/cancel/push"
        
    }
    
    struct URL {
        static let inviteChall  = "https://challinvite"
        static let deeplinkHost = "danharu://"
        
        struct UniversalLink {
            static let moveToTodoDetail = URL.deeplinkHost + "movetododetail"
        }
    }
    
}

var keyboardH: CGFloat = 0
