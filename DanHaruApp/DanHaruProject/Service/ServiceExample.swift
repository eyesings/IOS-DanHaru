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
    static func userLoginService(completionHandler: @escaping (NSDictionary?) -> Void) {
        let dic: NSDictionary? = NSDictionary()
        completionHandler(dic)
    }
}
