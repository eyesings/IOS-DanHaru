//
//  TodoViewModel.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation

class TodoViewModel {
    var model: [TodoModel] = []
    var todoModel = TodoModel()
    
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
                    
                    self.todoModel = TodoModel.init(mem_id: todoListDic["mem_id"] as? String,
                                                   created_at: todoListDic["created_at"] as? String,
                                                   title: todoListDic["title"] as? String,
                                                   ed_date: todoListDic["ed_date"] as? String,
                                                   noti_time: todoListDic["noti_time"] as? String,
                                                   challange_status: todoListDic["challange_status"] as? String,
                                                   certi_yb: todoListDic["certi_yb"] as? String,
                                                   updated_user: todoListDic["updated_user"] as? String,
                                                   updated_at: todoListDic["updated_at"] as? String,
                                                   todo_id: todoListDic["todo_id"] as? Int,
                                                   fr_date: todoListDic["fr_date"] as? String,
                                                   noti_cycle: todoListDic["noti_cycle"] as? String,
                                                   todo_status: todoListDic["todo_status"] as? String,
                                                   chaluser_yn: todoListDic["chaluser_yn"] as? String,
                                                   created_user: todoListDic["created_user"] as? String)
                    
                }
            }
            self.model.append(self.todoModel)
            NotificationCenter.default.post(name: Configs.NotificationName.todoListFetchDone, object: true)
        }
    }
}
