//
//  TodoService.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/02.
//

import Foundation



extension ViewModelService {
    
    /// 리스트 조회
    static func todoListService(searchDate date: String, completionHandler: @escaping ([NSDictionary]?) -> Void) {
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
            DispatchQueue.main.async {
                RadHelper.getRootViewController()?.showNetworkErrorView(isNeedRetry: true)
            }
        }

    }
    
    /// 리스트 등록
    static func todoRegisterService(param: [String:Any], completionHandler: @escaping () -> Void) {
        
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
            DispatchQueue.main.async {
                RadHelper.getRootViewController()?.showNetworkErrorView(isNeedRetry: true)
            }
        }
    }
}
