//
//  ViewModelExample.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import Foundation

class ExampleViewModel {
    var model: ExampleModel = ExampleModel()
    
    init() {
        ServiceExample.exampleFunc { dic in
            if let modelDic = dic {
                do {
                    self.model = try JSONDecoder().decode(ExampleModel.self, from: JSONSerialization.data(withJSONObject: modelDic))
                }
                catch {
                    Dprint(error)
                    
                    self.model.exampleStr = nil
                    self.model.exampleInt = nil
                }
            }
        }
    }
}
