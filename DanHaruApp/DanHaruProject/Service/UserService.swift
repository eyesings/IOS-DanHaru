//
//  UserService.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/02.
//

import Foundation
import UIKit


extension ViewModelService {
    
    /// 회원가입
    static func userJoinService(_ param: [String:Any], completionHandler: @escaping () -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { print("rootVC 없음"); return }
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.join, parameters: param) { resultDic in
            if let dic = resultDic {
                if let codeStr = dic["status_code"] as? String, codeStr != APIResultCode.success.rawValue,
                   let msgStr = dic["msg"] as? String {
                    RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title, message: msgStr, isNeedCancel: false, viewController: rootVC) { if $0 { rootVC.hideLoadingView() } }
                } else {
                    completionHandler()
                    NotificationCenter.default.post(name: Configs.NotificationName.userLoginSuccess, object: true)
                }
            }
        } errorHandler: { err in
            print("error \(err)")
            DispatchQueue.main.async {
                rootVC.hideLoadingView()
                NotificationCenter.default.post(name: Configs.NotificationName.userLoginSuccess, object: false)
            }
        }

        
    }
    
    /// 로그인 유효값 확인
    static func userInputValidValueService(_ param: [String:Any], _ type: InputType, completionHandler: @escaping (Bool) -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { print("rootVC 없음"); return }
        
        rootVC.showLoadingView()
        
        var apiUrl = ""
        if type == .email { apiUrl = Configs.API.validEmail }
        else if type == .id { apiUrl = Configs.API.validID }
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: apiUrl, parameters: param) { resultDic in
            
            if let dic = resultDic, let rsltCode = dic["status_code"] as? String, let code = APIResultCode.init(rawValue: rsltCode) {
                
                completionHandler(code == .success)
            }
            rootVC.hideLoadingView()
        } errorHandler: { err in
            Dprint("error \(err)")
            DispatchQueue.main.async {
                rootVC.hideLoadingView()
                errorHandler(.UserValidate)
            }
        }

    }
    
    /// 로그인 및 유저 정보 확인
    static func userInfoService(_ id: String, _ pw: String, completionHandler: @escaping (NSDictionary?) -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        let rootVC = RadHelper.getRootViewController()
        
        func rootVCHideLoadingView() {
            rootVC?.hideLoadingView()
        }
        
        var param: [String:Any] = [:]
        param["id"] = id
        param["pw"] = pw
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.login, parameters: param) { resultDic in
            if let statusCodeStr = resultDic?["status_code"] as? String,
               let statusCode = APIResultCode.init(rawValue: statusCodeStr),
               statusCode == .success,
               let userDic = resultDic?["detail"] as? NSDictionary {
                completionHandler(userDic)
                NotificationCenter.default.post(name: Configs.NotificationName.userLoginSuccess, object: true)
                rootVCHideLoadingView()
            } else if let msgStr = resultDic?["msg"] as? String {
                RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title, message: msgStr, isNeedCancel: false, viewController: rootVC ?? UIViewController()) { if $0 { rootVCHideLoadingView() } }
            }
        } errorHandler: { err in
            Dprint("error \(err)")
            DispatchQueue.main.async {
                rootVCHideLoadingView()
                errorHandler(.UserLogin)
            }
        }
    }
    
    
    /// 유저 정보 업데이트
    static func userInfoUpdateService(_ name: String = "", _ image: UIImage?, _ intro: String = "", completionHandler: @escaping () -> Void, errorHandler: @escaping (APIType) -> Void) {
        var param: [String:Any] = [:]
        param["profile_nm"] = name
        param["profile_into"] = intro
        param["uploaded_file"] = image
        
        let apiStr = RadHelper.makeString(With: [Configs.API.updateUser, "/\(UserModel.memberId ?? "")", "/\(UserModel.memberEmail ?? "")"])
        
        RadServerNetwork.putDataFromServer(url: apiStr,
                                           parameters: param,
                                           isForUploadImg: true) { resultData in
            print("resultData \(resultData)")
            _ = UserInfoViewModel.init((resultData?["detail"] as? NSDictionary)) {
                completionHandler()
            } errHandler: { errorHandler($0) }
        } errorHandler: { error in
            print("err \(error)")
            errorHandler(.UserUpdate)
        }

    }
    
    /// 유저 할일, 도전, 완료 카운트 서비스
    /// - Parameters:
    ///   - completionHandler: 서버 통신 성공
    ///   - errHandler: 서버 통신 실패
    static func userTodoCntInfoService(completionHandler: @escaping (NSDictionary?) -> Void, errHandler: @escaping (APIType) -> Void) {
        
        var param: [String:Any] = [:]
        param["mem_id"] = UserModel.memberId
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.getUsrTodo, parameters: param) { resultData in
            if let resultCode = resultData?["status_code"] as? String,
               resultCode == APIResultCode.success.rawValue {
                completionHandler(resultData?["detail"] as? NSDictionary)
            }
        } errorHandler: { err in
            Dprint("error  \(err)")
            errHandler(.UserTodoCnt)
        }

    }
    
    
    static func userTotalTodoListService(completionHandler: @escaping (NSDictionary?) -> Void, errHandler: @escaping (APIType) -> Void) {
        
        var param: [String:Any] = [:]
        param["mem_id"] = UserModel.memberId
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.getUsrAll,
                                                       parameters: param) { resultDic in
            if let resultCode = resultDic?["status_code"] as? String,
               resultCode == APIResultCode.success.rawValue {
                completionHandler(resultDic?["detail"] as? NSDictionary)
            }
        } errorHandler: { error in
            Dprint("error \(error)")
            errHandler(.UserAllTodoList)
        }

    }
}
