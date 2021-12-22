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
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.todoList, parameters: param) { resultDic in
            if let resultDic = resultDic,
               let resultArr = resultDic["detail"] as? [NSDictionary] {
                completionHandler(resultArr)
            } else {
                completionHandler(nil)
            }
        } errorHandler: { err in
            Dprint("error \(err)")
            errorHandler(.TodoList)
        }

    }
    
    /// 리스트 등록
    static func todoRegisterService(param: [String:Any], completionHandler: @escaping () -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
        
        rootVC.showLoadingView()
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.createTodo, parameters: param) { resultDic in
            if let resultCode = resultDic?["status_code"] as? String,
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
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.todoDelete, parameters: param) { resultDic in
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
