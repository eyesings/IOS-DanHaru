//
//  ServiceExample.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import Foundation


class ServiceExample {
    func exampleFunc(completionHandler: @escaping (ExampleViewModel) -> Void) {
        // URLSession을 통한 서버 통신 후 viewModel Return
        let dic: NSDictionary? = NSDictionary()
        completionHandler(ExampleViewModel.init(withDic: dic))
    }
}
