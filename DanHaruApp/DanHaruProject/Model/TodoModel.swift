//
//  TodoModel.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation
// 컬럼명을 확인을 못해서 임의로 작성
struct TodoModel: Codable {
    var title: String?
    var checkAuth: String? // Y, N 으로 넘어오지 않을까 생각함
    var together: String? // Y, N 으로 넘어오지 않을까 생각함, 아니면 FK 로 사용될수도 있음(확실하지 않음)
    var Begin_date: Date?
    var End_date: Date?
    var ins_date: Date?
}
