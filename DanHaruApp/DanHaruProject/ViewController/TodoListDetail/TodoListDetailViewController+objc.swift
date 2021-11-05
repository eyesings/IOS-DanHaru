//
//  TodoListDetailViewController+objc.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/03.
//

import Foundation
import SnapKit
import UIKit

extension TodoListDetailViewController {
    
    @objc func tapDateLabel(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            
            /// 시작 날짜 클릭
            if tag == 1111 {
                
                let bottomVC = BottomSheetsViewController()
                bottomVC.modalPresentationStyle = .overFullScreen
                bottomVC.checkShowUI = "startDate"
                if let startDateText = self.startDateLabel.text {
                    bottomVC.preDate = startDateText
                }
                
                self.present(bottomVC, animated: true, completion: nil)

            } else {
                
                let bottomVC = BottomSheetsViewController()
                bottomVC.modalPresentationStyle = .overFullScreen
                bottomVC.checkShowUI = "endDate"
                if let endDateText = self.endDateLabel.text {
                    bottomVC.preDate = endDateText
                }
                self.present(bottomVC, animated: true, completion: nil)
                
            }
        }
    }

    /// 반복주기 클릭 - 클릭시 [String] 에 추가(차후 수정)
    @objc func circleBtnAction(_ sender: UIButton) {
        
        if sender.tag == 111 {
            print("월")
            // 선택
            if sender.viewWithTag(111)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("월")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "월"}
            }
            
        } else if sender.tag == 222 {
            print("화")
            if sender.viewWithTag(222)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("화")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "화" }
            }
            
        } else if sender.tag == 333 {
            print("수")
            if sender.viewWithTag(333)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("수")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "수" }
            }
            
        } else if sender.tag == 444 {
            print("목")
            if sender.viewWithTag(444)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("목")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "목" }
            }
        
        } else if sender.tag == 555 {
            print("금")
            if sender.viewWithTag(555)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("금")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "금" }
            }
            
        } else if sender.tag == 666 {
            print("토")
            if sender.viewWithTag(666)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("토")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "토" }
            }

        } else if sender.tag == 777 {
            print("일")
            if sender.viewWithTag(777)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("일")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "일" }
            }
            
        } else if sender.tag == 888 {
            print("매일")
            if sender.viewWithTag(888)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("매일")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "매일" }
            }
            
        }
        
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
