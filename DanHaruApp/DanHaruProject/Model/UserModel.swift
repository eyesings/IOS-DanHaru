//
//  UserModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation

/// 유저 로그인 모델
struct UserLoginModel: Codable {
    var id: String?
    var email: String?
    var pw: String?
}

/// 유저 정보 모델
struct UserInfoModel: Codable {
    var userIdx: String?
    var nickName: String?
    var profileImgUrl: String?
    var profileIntro: String?
    var todoCnt: Int?
    var challangeCnt: Int?
    var totalCnt: Int?
}
