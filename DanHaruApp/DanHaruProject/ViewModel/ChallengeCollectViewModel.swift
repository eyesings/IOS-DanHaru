//
//  ChallengeCollectViewModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/11.
//

import Foundation


/// 나의 도전 현황 뷰모델
class ChallengeCollectViewModel {
    var model: [TodoCollectModel] = []
    
    init() {
        ViewModelService.todoCollectService { infoDic in
            if let dic = infoDic, let dataDic = dic["data"] as? [NSDictionary]
            {
                for data in dataDic {
                    var _model = TodoCollectModel()
                    _model.title = data["title"] as? String
                    _model.startDate = data["sDate"] as? Date
                    _model.endDate = data["eDate"] as? Date
                    _model.isTogether = data["together"] as? Bool
                    _model.isCheck = data["isCheck"] as? Bool
                    _model.isTodo = data["todoYN"] as? Bool
                    
                    // modelType -> 진행중, 미완료, 완료 구분
                    // 종료일이 오늘보다 뒤이거나(아직 오지 않음) 같으면 진행중
                    // 종료일이 오늘과 같고, 인증 등록 여부 존재 시 완료. 인증 등록 여부 미존재 시 진행 중
                    // 종료일이 오늘보다 빠르고(이미 지났고) 인증 등록 여부 존재 시 완료, 인증 등록 여부 미존재 시 미완료
                    guard let endDate = _model.endDate else { return }
                    if endDate >= Date()
                    {
                        _model.modelStateType = .doing
                        if endDate == Date()
                        {
                            _model.modelStateType = _model.isCheck == true ? .done : .doing
                        }
                    }
                    else
                    {
                        if let check = _model.isCheck
                        {
                            _model.modelStateType = check ? .done : .fail
                        }
                    }
                    
                    // 함께하기 여부 체크 후, ture이면 할일 false이면 도전 타입
                    _model.modelCategory = _model.isTogether == true ? .myChallange : .todoList
                    
                    self.model.append(_model)
                    
                }
                
                
                
            }
            
            
            // test model
            self.model = [
                TodoCollectModel(title: "네이버 영단어 5가지 숙지", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: false, modelStateType: .done, modelCategory: .todoList),
                TodoCollectModel(title: "퇴근 후 운동 가기", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: false, modelStateType: .done, modelCategory: .todoList),
                TodoCollectModel(title: "샐러드 챙겨 먹기", startDate: nil, endDate: nil, isTodo: true, isCheck: false, isTogether: false, modelStateType: .fail, modelCategory: .todoList),
                TodoCollectModel(title: "물 1리터 마시기", startDate: nil, endDate: nil, isTodo: true, isCheck: false, isTogether: false, modelStateType: .fail, modelCategory: .todoList),
                TodoCollectModel(title: "날짜 초과 인증 없음, 미완료된 할 일", startDate: nil, endDate: nil, isTodo: true, isCheck: false, isTogether: false, modelStateType: .fail, modelCategory: .todoList),
                TodoCollectModel(title: "진행 중인 할 일", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: false, modelStateType: .doing, modelCategory: .todoList),
                TodoCollectModel(title: "진행 중인 할 일2", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: false, modelStateType: .doing, modelCategory: .todoList),
                TodoCollectModel(title: "진행 중인 할 일3", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: false, modelStateType: .doing, modelCategory: .todoList),
                TodoCollectModel(title: "진행 중인 할 일4", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: false, modelStateType: .doing, modelCategory: .todoList),
                TodoCollectModel(title: "리얼클래스 강의 듣기", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .doing, modelCategory: .myChallange),
                TodoCollectModel(title: "진행 중인 도전1", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .doing, modelCategory: .myChallange),
                TodoCollectModel(title: "진행 중인 도전2", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .doing, modelCategory: .myChallange),
                TodoCollectModel(title: "토익 점수 900점대 달성", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .fail, modelCategory: .myChallange),
                TodoCollectModel(title: "미완료 된 도전1", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .fail, modelCategory: .myChallange)
//                TodoCollectModel(title: "카페인 줄이기 100일 챌린지", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .done, modelCategory: .myChallange),
//                TodoCollectModel(title: "완료된 도전1", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .done, modelCategory: .myChallange),
//                TodoCollectModel(title: "완료된 도전2", startDate: nil, endDate: nil, isTodo: true, isCheck: true, isTogether: true, modelStateType: .done, modelCategory: .myChallange)
            ]
        }
    }
}
