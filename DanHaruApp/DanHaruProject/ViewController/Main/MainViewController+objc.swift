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
        bottomVC.bottomViewType = .todoAdd
        bottomVC.preDate = selectedDate
        self.present(bottomVC, animated: true, completion: nil)
    }
    
    /// 초대 링크 받았을 때
    @objc func inviteChallFromFriend(_ noti: NSNotification) {
        
        guard let notiInfoArr = noti.object as? [String:Any],
              let custId = notiInfoArr["custid"] as? String,
              let todoidxStr = notiInfoArr["todoidx"] as? String else { return }
        
        self.invitedTodoIdx = Int(todoidxStr)
        self.invitedFriendId = custId
        
        self.apiService(withType: .TodoDetail)
    }
    
}
