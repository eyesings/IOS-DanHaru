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
        
        self.bottomSheetView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.2)
            make.height.equalTo(bottomTitle)
            make.leading.equalTo(bottomTitle.snp.trailing).offset(self.bottomSheetView.frame.width * 0.05)
        }
        cancelBtn.setTitle("X", for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
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
        titleLabel.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
        }
        titleTextField.placeholder = "할 일을 등록해 주세요."
        titleTextField.textColor = .customBlackColor
        titleTextField.delegate = self
        titleTextField.adjustsFontSizeToFitWidth = true
        
        let startDateLabel = UILabel()
        self.bottomSheetView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        startDateLabel.text = "목표 일자 설정"
        startDateLabel.textAlignment = .left
        startDateLabel.font = .systemFont(ofSize: 15.0)
        startDateLabel.adjustsFontSizeToFitWidth = true
        startDateLabel.textColor = UIColor.black
        
        
        //self.bottomSheetViewController.view.frame.height / 2 - self.bottomSheetViewController.view.frame.height * 0.27 - 20
        
        commonInitBottomBtn(withTitle: "등록 하기")
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoAddAction(_:)), for: .touchUpInside)
        commonInitDatePicker()
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
        
    }
    
    //MARK: - Todo 추가 함수
    @objc func bottomTodoAddAction(_ sender: UIButton) {
        
        let startDate = self.datePicker.date.dateToStr()
        
        self.titleTextField.updateUI()
        guard let titleText = self.titleTextField.text, titleText.isEmpty != true else { self.titleTextField.becomeFirstResponder(); return }
        let randomColor = UIColor().generateRandomBackgroundColor()
        _ = TodoResgisterViewModel(searchDate: startDate, inputTitle: titleText, color: randomColor.hexStringFromColor()) { Dprint("error \($0)") }
        self.hideBottomSheetAndGoBack()
    }
    
    //MARK: - 키보드 관련 함수
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            self.view.frame.origin.y += keyboardHeight
            
        }
    }
    
}
