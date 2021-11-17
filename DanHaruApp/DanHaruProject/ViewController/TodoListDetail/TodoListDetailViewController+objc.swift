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
            if tag == DateLabelTag.startDateLabel.rawValue {
                
                let bottomVC = BottomSheetsViewController()
                bottomVC.modalPresentationStyle = .overFullScreen
                bottomVC.checkShowUI = BottomViewCheck.startDate.rawValue
                if let startDateText = self.startDateLabel.text {
                    bottomVC.preDate = startDateText
                }
                
                self.present(bottomVC, animated: true, completion: nil)

            } else if tag == DateLabelTag.endDateLabel.rawValue {
                
                let bottomVC = BottomSheetsViewController()
                bottomVC.modalPresentationStyle = .overFullScreen
                bottomVC.checkShowUI = BottomViewCheck.endDate.rawValue
                if let endDateText = self.endDateLabel.text {
                    bottomVC.preDate = endDateText
                }
                self.present(bottomVC, animated: true, completion: nil)
                
            }
        }
    }

    /// 반복주기 클릭 - 클릭시 [String] 에 추가(차후 수정)
    @objc func circleBtnAction(_ sender: UIButton) {
        
        if sender.tag == DayBtnTag.monday.rawValue {
            print("월")
            // 선택
            if sender.viewWithTag(DayBtnTag.monday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
            
        } else if sender.tag == DayBtnTag.tuesday.rawValue {
            print("화")
            if sender.viewWithTag(DayBtnTag.tuesday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
            
        } else if sender.tag == DayBtnTag.wednesday.rawValue {
            print("수")
            if sender.viewWithTag(DayBtnTag.wednesday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
            
        } else if sender.tag == DayBtnTag.thursday.rawValue {
            print("목")
            if sender.viewWithTag(DayBtnTag.thursday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
        
        } else if sender.tag == DayBtnTag.friday.rawValue {
            print("금")
            if sender.viewWithTag(DayBtnTag.friday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
            
        } else if sender.tag == DayBtnTag.saturday.rawValue {
            print("토")
            if sender.viewWithTag(DayBtnTag.saturday.rawValue)?.backgroundColor == .lightGrayColor {
                
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

        } else if sender.tag == DayBtnTag.sunday.rawValue {
            print("일")
            if sender.viewWithTag(DayBtnTag.sunday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
            
        } else if sender.tag == DayBtnTag.everyday.rawValue {
            print("매일")
            if sender.viewWithTag(DayBtnTag.everyday.rawValue)?.backgroundColor == .lightGrayColor {
                
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
