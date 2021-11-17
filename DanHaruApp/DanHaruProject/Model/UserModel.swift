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
    var mem_email: String?
    var profile_nm: String?
    var profile_img: String?
    var profile_into: String?
}
