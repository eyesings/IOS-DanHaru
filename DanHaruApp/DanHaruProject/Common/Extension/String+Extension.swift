//
//  String+Extension.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/09.
//

import Foundation
import UIKit


extension String {
    
    func decodeEmoji() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encodeEmoji() -> String {
        guard let data = self.data(using: .nonLossyASCII, allowLossyConversion: true) else { return self }
        return String(data: data, encoding: .utf8) ?? self
    }
    
    func stringToDate(format: String = RadMessage.DateFormattor.apiParamType) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
}


extension UILabel {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 10.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
    
}
