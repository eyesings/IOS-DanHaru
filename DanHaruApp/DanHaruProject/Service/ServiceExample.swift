//
//  ServiceExample.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import Foundation
import UIKit


class ServiceExample {
    static func exampleFunc(completionHandler: @escaping (NSDictionary?) -> Void) {
        // URLSession을 통한 서버 통신 후 dictionary(ViewModel Init 가능한 타입) Return
        let dic: NSDictionary? = NSDictionary()
        completionHandler(dic)
    }
}


class ViewModelService {
    
    static func userJoinService(_ param: [String:Any], completionHandler: @escaping () -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { print("rootVC 없음"); return }
        
        RadServerNetwork.postDataFromServer(url: Configs.API.join, type: .JSON, parameters: param) { resultDic in
            if let dic = resultDic {
                if let msgStr = dic["msg"] as? String {
                    RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title, message: msgStr, isNeedCancel: false, viewController: rootVC) { if $0 { rootVC.hideLoadingView() } }
                } else {
                    completionHandler()
                    NotificationCenter.default.post(name: Configs.NotificationName.userLoginSuccess, object: true)
                }
            }
        } errorHandler: { err in
            print("error \(err)")
            rootVC.hideLoadingView()
            NotificationCenter.default.post(name: Configs.NotificationName.userLoginSuccess, object: false)
        }

        
    }
    
    static func userInputValidValueService(_ param: [String:Any], _ type: InputType, completionHandler: @escaping (Bool) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { print("rootVC 없음"); return }
        
        rootVC.showLoadingView()
        
        var apiUrl = ""
        if type == .email { apiUrl = Configs.API.validEmail }
        else if type == .id { apiUrl = Configs.API.validID }
        
        RadServerNetwork.postDataFromServer(url: apiUrl, type: .JSON, parameters: param) { resultDic in
            
            if let dic = resultDic, let rsltCode = dic["result_code"] as? String, let code = APIResultCode.init(rawValue: rsltCode) {
                
                completionHandler(code == .success)
            }
            rootVC.hideLoadingView()
        } errorHandler: { err in
            Dprint("error \(err)")
            rootVC.hideLoadingView()
            RadHelper.getRootViewController()?.showNetworkErrorView(isNeedRetry: true)
        }

    }
    
    static func userInfoService(_ id: String, _ pw: String, completionHandler: @escaping (NSDictionary?) -> Void) {
        
        
        let rootVC = RadHelper.getRootViewController()
        
        func rootVCHideLoadingView() {
            rootVC?.hideLoadingView()
        }
        
        var param: [String:Any] = [:]
        param["id"] = id
        param["pw"] = pw
        
        RadServerNetwork.postDataFromServer(url: Configs.API.login, type: .JSON, parameters: param) { resultDic in
            if let msgStr = resultDic?["msg"] as? String {
                RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title, message: msgStr, isNeedCancel: false, viewController: rootVC ?? UIViewController()) { if $0 { rootVCHideLoadingView() } }
            } else {
                completionHandler(resultDic)
                NotificationCenter.default.post(name: Configs.NotificationName.userLoginSuccess, object: true)
                rootVCHideLoadingView()
            }
        } errorHandler: { err in
            Dprint("error \(err)")
            rootVCHideLoadingView()
            rootVC?.showNetworkErrorView(isNeedRetry: true)
        }
    }
    
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
            RadHelper.getRootViewController()?.showNetworkErrorView(isNeedRetry: true)
        }

    }
    
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
            RadHelper.getRootViewController()?.showNetworkErrorView(isNeedRetry: true)
        }
    }
    
    static func todoCollectService(completionHandler: @escaping (NSDictionary?) -> Void) {
        let dic: NSDictionary? = NSDictionary()
        completionHandler(dic)
    }
}

