//
//  TodoModel.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation


struct TodoModel: Codable {
    var mem_id: String?
    var created_at: String?
    var title: String?
    var ed_date: String?
    var noti_time: String?
    var challange_status: String?
    var certi_yb: String?
    var updated_user: String?
    var updated_at: String?
    var todo_id: Int?
    var fr_date: String?
    var noti_cycle: String?
    var todo_status: String?
    var chaluser_yn: String?
    var created_user: String?
}

struct TodoRegisterModel {
    var mem_id: String?
    var title: String?
    var fr_date: String?
    
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
