//
//  BottomSheetsViewController+function.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/03.
//

import Foundation
import SnapKit
import UIKit

extension BottomSheetsViewController {
    
    /// TodoList 추가
    func setLayout() {
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView)
            make.centerX.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.5)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.1)
        }
        bottomTitle.text = "일정 등록"
        bottomTitle.textAlignment = .center
        bottomTitle.adjustsFontSizeToFitWidth = true
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 20)
        
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
        titleLabel.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
        }
        titleTextField.placeholder = "할 일을 등록해 주세요."
        titleTextField.textColor = UIColor.black
        titleTextField.delegate = self
        titleTextField.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        startDateLabel.text = "목표 일자 설정"
        startDateLabel.textAlignment = .left
        startDateLabel.adjustsFontSizeToFitWidth = true
        startDateLabel.textColor = UIColor.black
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.18)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.top.equalTo(self.startDateLabel.snp.bottom)
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        
        // datepicker 가 14로 넘어오면서 변경되서 분기처리
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //self.bottomSheetViewController.view.frame.height / 2 - self.bottomSheetViewController.view.frame.height * 0.27 - 20
        
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.width.equalTo(self.bottomSheetView)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.view.frame.height / 2 - self.view.frame.height * 0.43 + 10)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("등록 하기", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoAddAction(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
        
    }
    
    /// TodoListDetail 날짜 선택 UI 작성 함수
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
    
    override func viewDidLayoutSubviews() {
        titleTextField.makesToCustomField()
    }
    
    /// 바텀 뷰 화면 노출
    func showBottomSheet() {
        
        let safeAreaHeight:CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding:CGFloat = view.safeAreaInsets.bottom
        
        let constant = (safeAreaHeight + bottomPadding) - self.defaultHeight
        self.bottomSheetView.snp.remakeConstraints { make in
            make.top.equalTo(self.view).offset(constant)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            //self.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: constant)
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
            
        } completion: { (_) in
            
        }
    }
    
    /// 반복주기 UI 함수
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
    
    /*
    func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha:CGFloat = 0.7
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2
        
        let noDimPosition = safeAreaHeight + bottomPadding
        
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * ( 1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
    */
    
    
    /// 바텀 시트 뷰 숨김
    func hideBottomSheetAndGoBack() {
        //let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        //let bottomPadding = view.safeAreaInsets.bottom
        //bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    /// 날짜 변환 String -> Date
    func getStringToDate(_ date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        var convertDate = format.date(from: date)
        convertDate?.addTimeInterval(32400)
        
        guard let result = convertDate else { return Date() }
        
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
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
