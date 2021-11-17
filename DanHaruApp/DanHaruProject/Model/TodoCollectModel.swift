//
//  ChallengeCollectModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/11.
//

import Foundation


/// 내 도전 현황 리스트
struct TodoCollectModel {
    var title: String?
    var startDate: Date?
    var endDate: Date?
    var isTodo: Bool?
    var isCheck: Bool?
    var isTogether: Bool?
    var modelStateType: CollectionViewTag = .none
    var modelCategory: MyChallangeBtnTag = .todoList
}
