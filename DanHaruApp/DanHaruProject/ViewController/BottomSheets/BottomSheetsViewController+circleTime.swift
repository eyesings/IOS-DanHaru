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
        
        commonInitTitleLabel(withTitle: "반복주기 시간 선택")
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(30)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.38)
        }
        
        self.commonInitBottomBtn()
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoCheckTime(_:)), for: .touchUpInside)
    }
    
    
    @objc func bottomTodoCheckTime(_ sender: UIButton) {
        Configs.formatter.dateFormat = "HH:mm"
        let changeTime = Configs.formatter.string(from: self.datePicker.date)
        
        self.timeDelegate?.timeChange(changeTime)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
