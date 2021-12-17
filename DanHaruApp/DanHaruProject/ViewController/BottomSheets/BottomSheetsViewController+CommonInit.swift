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
    
    func commonInitDatePicker() {
        datePicker.datePickerMode = self.bottomViewType == .cycleTime ? .time : .date
        datePicker.minuteInterval = 10
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.setDate(preDate.stringToDate() ?? Date(), animated: false)
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.bottomSheetView)
            make.width.equalTo(screenwidth * 0.8)
            make.height.equalTo(datePicker.snp.width).multipliedBy(0.45)
            if self.bottomViewType == .todoAdd {
                make.bottom.equalTo(bottomTodoAddBtn.snp.top)
            } else {
                make.top.equalTo(self.bottomTitle.snp.bottom)
            }
        }
    }
    
    func commonInitBottomBtn(withTitle title: String = "확인", isNeedCustomLayout: Bool = false) {
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.width.equalTo(self.bottomSheetView)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        bottomTodoAddBtn.backgroundColor = .subHeavyColor
        bottomTodoAddBtn.setTitle(title, for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
    }
    
    func commonInitTitleLabel(withTitle title: String, fontSize size: CGFloat = 20) {
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.5)
            make.top.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(screenheight * 0.1)
        }
        
        bottomTitle.text = title
        bottomTitle.textAlignment = .center
        bottomTitle.textColor = .customBlackColor
        bottomTitle.font = UIFont.boldSystemFont(ofSize: size)
        bottomTitle.adjustsFontSizeToFitWidth = true
    }
}
