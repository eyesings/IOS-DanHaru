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
        commonInitDatePicker()
        
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoCheckTime(_:)), for: .touchUpInside)
    }
    
    
    @objc func bottomTodoCheckTime(_ sender: UIButton) {
        self.timeDelegate?.timeChange(self.datePicker.date.dateToStr(format: "HH : mm"))
        self.dismiss(animated: true, completion: nil)
    }
    
}
