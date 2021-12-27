//
//  BottomSheetsViewController+CommonInit.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/16.
//

import Foundation
import UIKit


// FIXME: 어디에 둬야할지 몰라서 일단 여기 둡니다. 원하는 위치로 이동시켜주세요.
extension BottomSheetsViewController {
    
    func commonInitDatePicker(withCustomLayout customTopConstView: UIView? = nil) {
        datePicker.datePickerMode = self.bottomViewType == .cycleTime ? .time : .date
        datePicker.minuteInterval = 10
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.setDate(preDate.stringToDate() ?? Date(), animated: false)
        if self.bottomViewType == .cycleTime {
            datePicker.setDate(selectedTime.stringToDate(format: "HH:mm") ?? Date(), animated: false)
        }
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.bottomSheetView)
            make.width.equalTo(screenwidth * 0.8)
            make.height.equalTo(datePicker.snp.width).multipliedBy(0.45)
            if let customView = customTopConstView {
                make.top.equalTo(customView.snp.bottom)
                return
            }
            if self.bottomViewType == .todoAdd {
                make.bottom.equalTo(bottomTodoAddBtn.snp.top)
            } else {
                make.top.equalTo(self.bottomTitle.snp.bottom)
            }
        }
    }
    
    func commonInitBottomBtn(withTitle title: String = "확인", isNeedCustomLayout: Bool = false) {
        self.view.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.width.equalTo(self.view)
        }
        self.bottomBtnBottomConst = bottomTodoAddBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.bottomBtnBottomConst.isActive = true
        bottomTodoAddBtn.backgroundColor = .subHeavyColor
        bottomTodoAddBtn.setTitle(title, for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
    }
    
    func commonInitTitleLabel(withTitle title: String, fontSize size: CGFloat = 20) {
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.5)
            make.top.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(60)
        }
        
        bottomTitle.text = title
        bottomTitle.textAlignment = .center
        bottomTitle.textColor = .customBlackColor
        bottomTitle.font = UIFont.boldSystemFont(ofSize: size)
        bottomTitle.adjustsFontSizeToFitWidth = true
    }
}
