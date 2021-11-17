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
        print("캘린더 상태 \(self.calendarShowOn)")
        // 캘린더가 열려있는 경우
        if(self.calendarShowOn) {
            self.calendarShowOn = false
            
            self.calendarAnimation.animation = .named("down-arrows")
            calendarAnimation.play()
            self.calendarView.snp.remakeConstraints { make in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(20)
                make.width.equalTo(self.view).multipliedBy(0.8)
                make.centerX.equalTo(self.view)
                make.height.equalTo(self.view).multipliedBy(0)
            }
                        
        } else {
            self.calendarShowOn = true
            
            self.calendarAnimation.animation = .named("up-arrows")
            calendarAnimation.play()
            self.calendarView.snp.remakeConstraints { make in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(20)
                make.width.equalTo(self.view).multipliedBy(0.8)
                make.centerX.equalTo(self.view)
                make.height.equalTo(self.view).multipliedBy(0.45)
            }
            
        }
        
    }
    
    @objc func addAction(_ button: UIButton) {
        print("바텀 시트")
        //self.setBottomSheetUI()
        /*
        let bottomVC = BottomSheetViewController(contentViewController: bottomSheetViewController)
        bottomVC.modalPresentationStyle = .overFullScreen
        self.present(bottomVC, animated: true, completion: nil)
        */
        
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.todoAdd.rawValue
        self.present(bottomVC, animated: true, completion: nil)
    }
    
    @objc func bottomSheetDismiss(_ button: UIButton) {
        self.bottomSheetViewController.dismiss(animated: false, completion: nil)
    }
    
}
