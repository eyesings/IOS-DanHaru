//
//  MainViewController+objc.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation
import UIKit

extension MainViewController {
    /// 캘린더 보여주기, 숨김 처리
    @objc func calendarShowHideAction(_ sender: UIButton = UIButton()) {
        
        calendarAnimation.animation = .named(calendarShowOn ? "down-arrows" : "up-arrows")
        calendarAnimation.play()
        calendarViewAnimation()
        if calendarShowOn == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.calendar.updateAndNotifyScrolling()
            }
        }
        calendarShowOn.toggle()
    }
    
    /// 투두 추가 버튼
    @objc func addAction(_ button: UIButton) {
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.todoAdd.rawValue
        self.present(bottomVC, animated: true, completion: nil)
    }
    
}
