//
//  UserViewModel.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation


/// 유저 로그인 뷰모델
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

/// 유저 정보 뷰모델
class UserInfoViewModel {
    var model: UserInfoModel = UserInfoModel()
    
    init(_ id: String, _ pw: String) {
        ViewModelService.userInfoService(id, pw) { infoDic in
            if let dic = infoDic
            {
                do {
                    self.model = try JSONDecoder().decode(UserInfoModel.self,
                                                          from: JSONSerialization.data(withJSONObject: dic))
                }
                catch {
                    Dprint(error)
                    
                    self.model.userIdx = dic["userIdx"] as? String
                    self.model.nickName = dic["nickName"] as? String
                    self.model.profileImgUrl = dic["profileImgUrl"] as? String
                    self.model.profileIntro = dic["profileIntro"] as? String
                    self.model.todoCnt = dic["todoCnt"] as? Int
                    self.model.challangeCnt = dic["challangeCnt"] as? Int
                    self.model.totalCnt = dic["totalCnt"] as? Int
                }
            }
        }
    }
}
