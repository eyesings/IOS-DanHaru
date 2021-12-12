//
//  TodoModel.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation


struct TodoModel: Codable {
    var todo_id: Int?
    var mem_id: String?
    var title: String?
    var fr_date: String?
    var ed_date: String?
    var noti_cycle: String?
    var noti_time: String?
    var todo_status: String?
    var challange_status: String?
    var chaluser_yn: String?
    var certi_yn: String?
    var use_yn: String?
    var color: String?
    var created_at: String?
    var created_user: String?
    var updated_at: String?
    var updated_user: String?
    var certification_list: [ChallengeCertiModel]?
    var challenge_user: [ChallengerUser]?
    var report_list_percent: [String:Int]?
}


/// 챌린저 진행 유저들 정보
struct ChallengerUser: Codable {
    var chaluser_id: Int?
    var created_at: String?
    var mem_id: String?
    var created_user: String?
    var updated_at: String?
    var todo_id: Int?
    var updated_user: String?
}

struct ChallengeCertiModel: Codable {
    var mem_id: String?
    var created_at: String?
    var certi_id: Int?
    var certi_img: String?
    var certi_check: String? // "Y" || "N"
    var updated_user: String?
    var todo_date: String?
    var certi_voice: String?
    var created_user: String?
}

struct TodoRegisterModel {
    var mem_id: String?
    var title: String?
    var fr_date: String?
    var color: String?
    
    func makesToParam() -> [String:Any] {
        let mirror = Mirror(reflecting: self)
        
        var dic: [String:Any] = [:]
        
        for (_, child) in mirror.children.enumerated() {
            if let label = child.label, let value = child.value as? String {
                dic[label] = value
            }
        }
        
        return dic
    }
}



struct TodoDetailUpdateModel: Codable {
    var title: String?
    var fr_date: String?
    var ed_date: String?
    var noti_cycle: String?
    var noti_time: String?
    var todo_status: String?
    var challange_status: String?
    var chaluser_yn: String?
    var certi_yn: String?
    
    func makesToParam() -> [String:Any] {
        let mirror = Mirror(reflecting: self)
        
        var dic: [String:Any] = [:]
        
        for (_, child) in mirror.children.enumerated() {
            if let label = child.label {
                dic[label] = child.value
            }
        }
        
        return dic
    }
}
