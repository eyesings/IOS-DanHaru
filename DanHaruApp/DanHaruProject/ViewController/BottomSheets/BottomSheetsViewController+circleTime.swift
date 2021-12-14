//
//  BottomSheetsViewController+circle.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/26.
//

import Foundation
import UIKit
import SnapKit
import Lottie

extension BottomSheetsViewController {
    
    //MARK: - 반복주기 시간 선택
    func setCirCleTimeLayout() {
        
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(25)
        }
        bottomTitle.text = "반복주기 시간 선택"
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
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
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
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoCheckTime(_:)), for: .touchUpInside)
    }
    
    
    @objc func bottomTodoCheckTime(_ sender: UIButton) {
        Configs.formatter.dateFormat = "HH:mm"
        let changeTime = Configs.formatter.string(from: self.datePicker.date)
        
        self.timeDelegate?.timeChange(changeTime)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
