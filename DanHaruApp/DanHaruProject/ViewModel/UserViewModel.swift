//
//  UserViewModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation
import UIKit


/// 유저 회원가입 뷰모델
class UserJoinViewModel {
    
    init(_ email: String, _ id: String, _ pw: String, errHandler: @escaping (APIType) -> Void) {
        var param: [String:Any] = [:]
        param["email"] = email
        param["id"] = id
        param["pw"] = pw
        ViewModelService.userJoinService(param) {
            let _ = UserInfoViewModel(id, pw)
        } errorHandler: { errHandler($0) }

    }
}

/// 유저 입력 값 유효 체크
class UserInfoValidCheckViewModel {
    
    static func checkIsValid(_ str: String, _ inputType: InputType, _ emailAddress: String = "", validCheckHandler: @escaping (Bool) -> Void, errHandler: @escaping (APIType) -> Void) {
        var param: [String:Any] = [:]
        param["id"] = inputType == .id ? str : ""
        param["email"] = inputType == .email ? str : emailAddress
        param["pw"] = ""
        
        ViewModelService.userInputValidValueService(param, inputType) { validCheckHandler($0) } errorHandler: { errHandler($0) }
    }
}

/// 유저 정보 뷰모델
class UserInfoViewModel {
    var model: UserInfoModel = UserInfoModel()
    
    init(_ id: String, _ pw: String, errHandler: ((APIType) -> Void)? = nil) {
        UserDefaults.standard.saveUserInputVal(id: id, pw: pw)
        ViewModelService.userInfoService(id, pw) { infoDic in
            self.initUserModel(infoDic) { errHandler?($0) }
        }
        errorHandler: { errHandler?($0) }
    }
    
    init(_ userDic: NSDictionary?, completionHandler: @escaping ()->Void,  errHandler: ((APIType) -> Void)? = nil) {
        self.initUserModel(userDic) {
            completionHandler()
        } errHandler: { errHandler?($0) }

    }
    
    private func initUserModel(_ dic: NSDictionary?, completeHandler: (()->Void)? = nil,  errHandler: ((APIType) -> Void)? = nil) {
        if let dic = dic as? [String:Any]
        {
            var saveUserDic: [String: Any] = [:]
            
            for keyValue in [String](dic.keys) {
                if let strVal = dic[keyValue] as? String {
                    let encryptStr = RadHelper.AES256Encrypt(WithValue: strVal)
                    saveUserDic[keyValue] = encryptStr
                }
            }
            
            do {
                self.model = try JSONDecoder().decode(UserInfoModel.self,
                                                      from: JSONSerialization.data(withJSONObject: saveUserDic))
            }
            catch {
                Dprint(error)
                
                self.model.mem_id = saveUserDic["mem_id"] as? String
                self.model.mem_email = saveUserDic["mem_email"] as? String
                self.model.profile_nm = saveUserDic["profile_nm"] as? String
                self.model.profile_img = saveUserDic["profile_img"] as? String
                self.model.profile_into = saveUserDic["profile_into"] as? String
                
            }
            
            UserModel = self.model
            completeHandler?()
        }
    }
}


/// 유저 정보 업데이트 뷰모델
class UserProfileUpdateViewModel {
    
    init(editedName name: String = "", editedIntro intro: String = "", editedImg img: UIImage? = nil, completionHandler: @escaping () -> Void, errHandler: @escaping (APIType) -> Void) {
        
        ViewModelService.userInfoUpdateService(name, img, intro) {
            completionHandler()
        } errorHandler: { errHandler($0) }
    }
}


/// 유저 할일, 도전, 완료 카운트 뷰모델
class UserTodoCntViewModel {
    
    private var model: UserTodoCntModel = UserTodoCntModel()
    
    init(completionHandler: @escaping (UserTodoCntModel) -> Void, errHandler: @escaping (APIType) -> Void) {
        ViewModelService.userTodoCntInfoService { resultData in
            if let resultDic = resultData {
                do {
                    self.model = try JSONDecoder().decode(UserTodoCntModel.self,
                                                          from: JSONSerialization.data(withJSONObject: resultDic))
                }
                catch
                {
                    Dprint(error)
                    
                    self.model.todo_complete_count = resultDic["todo_complete_count"] as? Int
                    self.model.todo_total_count = resultDic["todo_total_count"] as? Int
                    self.model.challenge_complete_count = resultDic["challenge_complete_count"] as? Int
                    self.model.challenge_total_count = resultDic["challenge_total_count"] as? Int
                }
                
                completionHandler(self.model)
            }
        } errHandler: { errHandler($0) }

    }
}
