//
//  UserLoginViewModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation


class UserLoginViewModel {
    var model: UserLoginModel = UserLoginModel()
    
    init() {
        ViewModelService.userLoginService { userLoginDic in
            if let dic = userLoginDic
            {
                do {
                    self.model = try JSONDecoder().decode(UserLoginModel.self, from: JSONSerialization.data(withJSONObject: dic))
                }
                catch {
                    Dprint(error)
                    
                    self.model.id = dic["id"] as? String
                    self.model.email = dic["email"] as? String
                    self.model.pw = dic["pw"] as? String
                }
                
            }
        }
    }
}
