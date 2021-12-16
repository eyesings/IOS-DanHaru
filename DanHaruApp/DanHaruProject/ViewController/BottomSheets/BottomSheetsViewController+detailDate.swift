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
        
        commonInitTitleLabel(withTitle: self.bottomViewType == .startDate ? "시작날짜 선택" : "종료날짜 선택")
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(30)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.38)
        }
        
        self.commonInitBottomBtn()
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoCheckDate(_:)), for: .touchUpInside)
    }
    
    @objc func bottomTodoCheckDate(_ sender: UIButton) {
        
        Configs.formatter.dateFormat = "yyyy-MM-dd"
        let changeDate = Configs.formatter.string(from: self.datePicker.date)
        
        dateDelegate?.dateChange(self.bottomViewType.rawValue, changeDate)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
