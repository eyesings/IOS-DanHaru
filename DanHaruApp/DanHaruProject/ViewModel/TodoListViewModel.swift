//
//  TodoViewModel.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation
import UIKit


/// Todo List 가져오는 VM
class TodoListViewModel {
    var model: [TodoModel] = []
    private var todoModel = TodoModel()
    
    init(searchDate date: String) {
        ViewModelService.todoListService(searchDate: date) { infoArr in
            guard let todoListArr = infoArr
            else {
                NotificationCenter.default.post(name: Configs.NotificationName.todoListFetchDone, object: false)
                return
            }
            
            for todoListDic in todoListArr {
                do {
                    self.todoModel = try JSONDecoder().decode(TodoModel.self,
                                                              from: JSONSerialization.data(withJSONObject: todoListDic))
                }
                catch {
                    Dprint(error)
                    
                    self.todoModel = TodoModel.init(todo_id: todoListDic["todo_id"] as? Int,
                                                    mem_id: todoListDic["mem_id"] as? String,
                                                    title: todoListDic["title"] as? String,
                                                    fr_date: todoListDic["fr_date"] as? String,
                                                    ed_date: todoListDic["ed_date"] as? String,
                                                    noti_cycle: todoListDic["noti_cycle"] as? String,
                                                    noti_time: todoListDic["noti_time"] as? String,
                                                    todo_status: todoListDic["todo_status"] as? String,
                                                    challange_status: todoListDic["challange_status"] as? String,
                                                    chaluser_yn: todoListDic["chaluser_yn"] as? String,
                                                    certi_yn: todoListDic["certi_yb"] as? String,
                                                    created_at: todoListDic["created_at"] as? String,
                                                    created_user: todoListDic["created_user"] as? String,
                                                    updated_at: todoListDic["updated_at"] as? String,
                                                    updated_user: todoListDic["updated_user"] as? String,
                                                    certification_list: todoListDic["certification_list"] as? [ChallengeCertiModel],
                                                    challenge_user: todoListDic["challenge_user"] as? [ChallengerUser])
                    
                    
                }
                self.model.append(self.todoModel)
            }
            NotificationCenter.default.post(name: Configs.NotificationName.todoListFetchDone, object: true)
        }
    }
}


/// Todo 등록하는 VM
class TodoResgisterViewModel {
    var param: [String:Any] = [:]
    
    init(searchDate date: String, inputTitle: String) {
        param = TodoRegisterModel.init(mem_id: UserModel.memberId, title: inputTitle, fr_date: date).makesToParam()
        ViewModelService.todoRegisterService(param: param) {
            NotificationCenter.default.post(name: Configs.NotificationName.todoListCreateNew, object: true)
        }
    }
}


/// 디테일 리스트 가져오는 VM
class TodoDetailViewModel {
    private var model: TodoModel = TodoModel()
    
    init(_ todoIdx: Int, _ searchDate: String, completionHandler: @escaping (TodoModel) -> Void) {
        ViewModelService.todoDetailDataService(todoIdx: todoIdx, searchDate: searchDate) { detailData in
            
            guard let dData = detailData else { return }
            
            do {
                self.model = try JSONDecoder().decode(TodoModel.self,
                                                      from: JSONSerialization.data(withJSONObject: dData))
            }
            catch {
                Dprint("occur error \(error)")
            }
            
            completionHandler(self.model)
        }
        
    }
}



/// 상세 화면 수정 or 친구 챌린지 초대 수락
class TodoDetailUpdateViewModel {
    private var model: TodoDetailUpdateModel = TodoDetailUpdateModel()
    
    init(_ todoModel: TodoModel, notiCycle: String?, notiTime: String?, completionHandler: @escaping () -> Void) {
        self.model = TodoDetailUpdateModel(title: todoModel.title,
                                           fr_date: todoModel.fr_date,
                                           ed_date: todoModel.ed_date,
                                           noti_cycle: notiCycle,
                                           noti_time: notiTime,
                                           todo_status: todoModel.todo_status,
                                           challange_status: todoModel.challange_status,
                                           chaluser_yn: todoModel.chaluser_yn,
                                           certi_yn: nil)
        
        let param = self.model.makesToParam()
        
        ViewModelService.todoDetailUpdteService(param: param, todoIdx: todoModel.todo_id ?? 0) { isComplete in
            if isComplete { completionHandler() }
        }
    }
}



/// 챌린지 유저 등록
class TodoCreateChallengeViewModel {
    
    init(_ todoIdx: Int, _ ownerMemId: String, completionHandler: @escaping () -> Void) {
        ViewModelService.todoCreateChaalengeService(todoIdx: todoIdx, ownerMemId: ownerMemId) { isComplete in
            if isComplete { completionHandler() }
        }
    }
}
