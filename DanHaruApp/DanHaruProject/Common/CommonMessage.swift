//
//  CommonMessage.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/15.
//

import Foundation


extension RadMessage {
    struct Network {
        static let reBuildLater = "잠시후 다시 시도해 주세요."
        static let networkErr   = "네트워크 오류"
        static let networkErrMsg = "네트워크에 연결되어 있지 않아요!"
    }
    
    struct Main {
        static let noneTodoListInfo    = "오늘의 목표가 없어요!"
        static let noneTodoListSubInfo = "일정을 등록하여 손쉽게 관리하여 보세요.\n친구를 초대하여 같은 목표를 향해 함께 도전해 보세요."
        static let noneTodoListAddTodo = "오늘 할 일 등록하러 가기"
    }
    
    struct ASK {
        static let askAddSuccess             = "문의가 정상 등록 되었습니다."
        static let emailNotInputErrIsLogin   = "이메일을 입력해 주세요. 확인 버튼 클릭 시 현재 로그인한 계정으로 문의가 등록됩니다."
        static let emailNotInputErrNoneLogin = "답변을 받을 이메일을 입력 해 주세요."
        static let emailError                = "이메일 형식이 올바르지 않습니다."
        static let askTextCntErr             = "문의 사항을 최소 10글자이상 등록해 주세요."
        static let textViewInfoStr           = "* 영업일 기준 2~3일 이내에 답변이 완료 됩니다."
    }
    
    struct Setting {
        static let logoutMsg     = "로그아웃하시겠습니까?"
        static let accountDelMsg = "회원 정보를 삭제하시겠습니까?"
        static let returnToLogin = "로그인 페이지로 이동하시겠습니까?\n취소 선택 시 메인으로 이동됩니다."
    }
    
    struct MyPage {
        static let savePhotoSuccess = "내 도전 현황 저장에 성공 하였습니다."
        static let savePhotoFail    = "내 도전 현황 저장에 실패 하였습니다."
    }
    
    struct ProfileEdit {
        static let saveProfile = "프로필 정보가 변경되었습니다."
        static let detectEmpty = "공백은 사용할 수 없어요."
    }
    
    struct UserJoin {
        static let notValidEmail     = "* 올바른 이메일 형식이 아니에요."
        static let alreadyExistEmail = "* 이미 존재하는 이메일이에요."
        static let alreadyExistId    = "* 이미 존재하는 아이디예요."
        static let placeHolderInfo   = "입력해 주세요."
    }
    
    struct AlertView {
        static let inputPasswordTitle = "새로운 비밀번호를 입력해 주세요."
        static let change             = "변경하기"
        static let disableInvite      = "친구 초대에 실패했어요. 잠시후 다시 시도해 주세요."
        static let cntAuthBeforInvite = "초대에 수락하기 전에는 인증할 수 없어요."
        static let cntInviteFriend    = "비회원은 초대할 수 없어요.\n회원가입 후 다시 시도해 주세요."
        static let notiStateChangeOff = "확인을 누르시면 재촉 수신이 불가해요."
        static let notiStateChangeOn  = "확인을 누르시면 재촉 수신을 할 수 있어요."
        static let inputImgMaxCount   = "인증 가능한 이미지는 최대 3장이에요."
        static let alreadyRegistAuth  = "이미 인증하였어요."
        static let noRegistAuth       = "인증을 해주세요."
        static let authUploadFail     = "인증에 실패하였습니다. 다시 시도해주세요."
        static let successUptDetail   = "저장했어요."
        static let useNTodoChallenge  = "삭제된 챌린지에요."
    }
    
    struct FindUserInfo {
        static let preFindId    = "발견한 아이디는 "
        static let sufFindId    = " 입니다."
        static let fontName     = "Menlo-Bold"
        static let inputReSetPW = "비밀번호로 재설정할 값을 입력해 주세요."
        static let copyID       = "아이디가 복사되었습니다."
    }
    
    struct Permission {
        static let permissionDenied = "권한이 허용 되어있지 않습니다.\n 설정페이지로 이동하시겠습니까?"
        static let reqLibraryAuth = "단하루 앱에 이미지를 사용하기 위해 사진첩 접근 권한이 필요합니다.\n확인을 누르시면 설정으로 이동됩니다."
    }
    
    struct DateFormattor {
        static let monthDate    = "MM월 dd일"
        static let apiParamType = "yyyy-MM-dd"
        static let timeDate     = "HH:mm"
    }
}
