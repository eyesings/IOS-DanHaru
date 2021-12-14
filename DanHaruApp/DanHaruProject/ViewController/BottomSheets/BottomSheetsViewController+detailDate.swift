//
//  BottomSheetsViewController+detailDate.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/26.
//

import Foundation
import SnapKit
import UIKit

extension BottomSheetsViewController {
    
    //MARK: - TodoListDetail: 시작날짜, 종료날짜 선택
    func setDateLayout() {
        
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(25)
        }
        switch self.checkShowUI {
        case BottomViewCheck.startDate.rawValue:
            bottomTitle.text = "시작날짜 선택"
        case BottomViewCheck.endDate.rawValue:
            bottomTitle.text = "종료날짜 선택"
        default:
            print("UI 판단 문자 체크 불가 오류, 문자 확인")
        }
        bottomTitle.textAlignment = .center
        bottomTitle.textColor = .black
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 25)
        bottomTitle.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(30)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.38)
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        if self.preDate != "" {
            print(preDate)
            datePicker.date = self.getStringToDate(preDate)
        }
        
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(self.view.frame.height / 2 - self.view.frame.height * 0.38 - 60)
            make.width.equalTo(self.bottomSheetView)
            make.centerX.equalTo(self.bottomSheetView)
            //make.height.equalTo(self.view.frame.height / 2 - self.view.frame.height * 0.38 - 10)
            make.height.equalTo(60)
            //make.bottom.equalTo(self.bottomSheetView)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("확인", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoCheckDate(_:)), for: .touchUpInside)
    }
    
    @objc func bottomTodoCheckDate(_ sender: UIButton) {
        
        Configs.formatter.dateFormat = "yyyy-MM-dd"
        let changeDate = Configs.formatter.string(from: self.datePicker.date)
        
        dateDelegate?.dateChange(self.checkShowUI, changeDate)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
