//
//  UserModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation


/// 유저 정보 모델
struct UserInfoModel: Codable {
    var mem_id: String?
    var memberId: String? {
        get { return mem_id != nil ? RadHelper.AES256Decrypt(WithValue: mem_id) : nil }
    }
    var mem_email: String?
    var memberEmail: String? {
        get { return mem_email != nil ? RadHelper.AES256Decrypt(WithValue: mem_email) : nil }
    }
    var profile_nm: String?
    var profileName: String? {
        get { return profile_nm != nil ? RadHelper.AES256Decrypt(WithValue: profile_nm).decodeEmoji() : nil }
    }
    var profile_img: String?
    var profileImgUrl: String? {
        get { return profile_img != nil ? RadHelper.AES256Decrypt(WithValue: profile_img) : nil }
    }
    var profile_into: String?
    var profileIntroStr: String? {
        get { return profile_into != nil ? RadHelper.AES256Decrypt(WithValue: profile_into).decodeEmoji() : nil }
    }
}



struct UserTodoCntModel: Codable {
    var todo_complete_count: Int?
    var todo_total_count: Int?
    var challenge_complete_count: Int?
    var challenge_total_count: Int?
}
