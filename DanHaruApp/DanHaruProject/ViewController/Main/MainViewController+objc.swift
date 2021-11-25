//
//  MainViewController+objc.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import Foundation
import UIKit

extension MainViewController {
    
    @objc func calendarShowHideAction(_ sender: UIButton) {
        // 캘린더가 열려있는 경우
        calendarAnimation.animation = .named(calendarShowOn ? "down-arrows" : "up-arrows")
        calendarAnimation.play()
        calendarViewAnimation()
        calendarShowOn.toggle()
    }
    
    @objc func addAction(_ button: UIButton) {
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.todoAdd.rawValue
        self.present(bottomVC, animated: true, completion: nil)
    }
    
}
