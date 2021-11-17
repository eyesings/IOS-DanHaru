//
//  CommonMessage.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/15.
//

import Foundation


extension RadMessage {
    struct ASK {
        static let askAddSuccess    = "문의가 정상 등록 되었습니다."
        static let emailNotInputErr = "이메일을 입력해 주세요. 확인 버튼 클릭 시 현재 로그인한 계정으로 문의가 등록됩니다."
        static let emailError       = "이메일 형식이 올바르지 않습니다."
        static let askTextCntErr    = "문의 사항을 최소 10글자이상 등록해 주세요."
        static let textViewInfoStr  = "* 영업일 기준 2~3일 이내에 답변이 완료 됩니다."
    }
    
    struct Setting {
        static let logoutMsg     = "로그아웃하시겠습니까?"
        static let accountDelMsg = "회원 정보를 삭제하시겠습니까?"
    }
    
    struct MyPage {
        static let savePhotoSuccess = "내 도전 현황 저장에 성공 하였습니다."
        static let savePhotoFail    = "내 도전 현황 저장에 실패 하였습니다."
    }
    
    struct ProfileEdit {
        static let saveProfile = "프로필 정보가 변경되었습니다."
    }
    
    struct UserJoin {
        static let notValidEmail     = "* 올바른 이메일 형식이 아니에요."
        static let alreadyExistEmail = "* 이미 존재하는 이메일이에요."
        static let alreadyExistId    = "* 이미 존재하는 아이디예요."
        static let placeHolderInfo   = "입력해 주세요."
        
        
    }
}
