//
//  String+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/09.
//

import Foundation


extension String {
    
    func decodeEmoji() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encodeEmoji() -> String {
        guard let data = self.data(using: .nonLossyASCII, allowLossyConversion: true) else { return self }
        return String(data: data, encoding: .utf8) ?? self
    }
}
