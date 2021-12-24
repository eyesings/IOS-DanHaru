//
//  BottomSheetsViewController+todoAdd.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/26.
//

import Foundation
import SnapKit
import UIKit

extension BottomSheetsViewController {
    
    //MARK: - 투두 리스트 추가 UI 함수
    func setLayout() {
        
        commonInitTitleLabel(withTitle: "일정 등록")
        
        let padding = screenwidth * 0.02
        
        self.bottomSheetView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.2)
            make.height.equalTo(bottomTitle)
            make.leading.equalTo(bottomTitle.snp.trailing).offset(self.bottomSheetView.frame.width * 0.05)
        }
        cancelBtn.setTitle("X", for: .normal)
        cancelBtn.setTitleColor(.customBlackColor, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cancelBtn.addTarget(self, action: #selector(bottomSheetDismiss(_:)), for: .touchUpInside)
        
        self.bottomSheetView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomTitle.snp.bottom)
            make.width.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.05)
            make.leading.equalTo(self.bottomSheetView).offset(30)
        }
        titleLabel.text = "목표 설정"
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 15.0)
        
        self.bottomSheetView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding*2)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(screenwidth * 0.8)
        }
        titleTextField.placeholder = "할 일을 등록해 주세요."
        titleTextField.textColor = .customBlackColor
        titleTextField.delegate = self
        
        let startDateLabel = UILabel()
        self.bottomSheetView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(padding)
            make.leading.equalTo(titleLabel)
        }
        startDateLabel.text = "목표 일자 설정"
        startDateLabel.textAlignment = .left
        startDateLabel.font = .systemFont(ofSize: 15.0)
        startDateLabel.textColor = UIColor.black
        
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoAddAction(_:)), for: .touchUpInside)
        commonInitDatePicker(withCustomLayout: startDateLabel)
        
    }
    
    //MARK: - Todo 추가 함수
    @objc func bottomTodoAddAction(_ sender: UIButton) {
        
        self.titleTextField.updateUI()
        
        guard let titleText = self.titleTextField.text,
              titleText.isEmpty != true
        else { self.titleTextField.becomeFirstResponder(); return }
        self.apiService(withType: .TodoCreate)
        self.hideBottomSheetAndGoBack()
    }
    
}
