//
//  ServiceExample.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import Foundation


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
                }
            }
        } errorHandler: { err in
            print("error \(err)")
            rootVC.hideLoadingView()
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
        }

    }
    
    static func userInfoService(_ id: String, _ pw: String, completionHandler: @escaping (NSDictionary?) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { print("rootVC 없음"); return }
        
        var param: [String:Any] = [:]
        param["id"] = id
        param["pw"] = pw
        
        RadServerNetwork.postDataFromServer(url: Configs.API.login, type: .JSON, parameters: param) { resultDic in
            if let msgStr = resultDic?["msg"] as? String {
                RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title, message: msgStr, isNeedCancel: false, viewController: rootVC) { if $0 { rootVC.hideLoadingView() } }
            } else {
                completionHandler(resultDic)
                rootVC.hideLoadingView()
            }
        } errorHandler: { err in
            print("error \(err)")
            rootVC.hideLoadingView()
        }
    }
    
    static func todoCollectService(completionHandler: @escaping (NSDictionary?) -> Void) {
        let dic: NSDictionary? = NSDictionary()
        completionHandler(dic)
    }
}
