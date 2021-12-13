//
//  TodoService.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/02.
//

import Foundation



extension ViewModelService {
    
    /// 리스트 조회
    static func todoListService(searchDate date: String, completionHandler: @escaping ([NSDictionary]?) -> Void, errorHandler: @escaping (APIType) -> Void) {
        var param: [String:Any] = [:]
        param["mem_id"] = UserModel.memberId ?? UserDefaults.userInputId
        param["fr_date"] = date
        
        RadServerNetwork.postDataFromServer(url: Configs.API.todoList, parameters: param) { resultData in
            if let resultArr = resultData {
                var resultDic: [NSDictionary]? = []
                for dic in resultArr {
                    if let infoDic = dic as? NSDictionary
                    {
                        if let _ = infoDic["result_code"] as? String { return }
                        resultDic?.append(infoDic)
                    }
                }
                completionHandler(resultDic)
            } else {
                completionHandler(nil)
            }
        } errorHandler: { error in
            Dprint("error \(error)")
            errorHandler(.TodoList)
        }

    }
    
    /// 리스트 등록
    static func todoRegisterService(param: [String:Any], completionHandler: @escaping () -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
        
        rootVC.showLoadingView()
        
        RadServerNetwork.postDataFromServer(url: Configs.API.createTodo, type: .JSON, parameters: param) { resultDic in
            if let resultCode = resultDic?["result_code"] as? String,
               resultCode == APIResultCode.failure.rawValue {
                RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title,
                                                           message: RadMessage.Network.reBuildLater,
                                                           isNeedCancel: false,
                                                           viewController: rootVC)
            }
            completionHandler()
        } errorHandler: { err in
            Dprint("error \(err)")
            errorHandler(.TodoCreate)
        }
    }
    
    
    /// 항목 삭제
    static func todoDeleteService(todoIdx: Int, completionHandler: @escaping () -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        var param: [String:Any] = [:]
        param["todo_id"] = "\(todoIdx)"
        param["mem_id"] = UserModel.memberId ?? ""
        
        
        RadServerNetwork.postDataFromServer(url: Configs.API.todoDelete, type: .JSON, parameters: param) { resultDic in
            print("resultData \(resultDic)")
            if let resultCode = resultDic?["result_code"] as? String,
               resultCode == APIResultCode.success.rawValue {
                completionHandler()
            }
        } errorHandler: { error in
            Dprint("error \(error)")
            errorHandler(.TodoDelete)
        }


    }
}
