//
//  MainViewController+function.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/28.
//

import Foundation
import UIKit
import SnapKit
import Lottie

extension MainViewController {
    // MARK: - 메인 뷰 UI 작성 함수
    func setUI() {
        
        self.view.addSubview(dateLabel)
        Configs.formatter.dateFormat = "MM월 dd일"
        let current_date_string = Configs.formatter.string(from: Date())
        dateLabel.text = current_date_string
        dateLabel.textAlignment = .left
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = dateLabel.font.withSize(25)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(60)
            make.leading.equalTo(self.view).offset(40)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view).multipliedBy(0.03)
        }
        
        /// 아래 버튼, 캘린더 노출
        self.view.addSubview(calendarAnimation)
        calendarAnimation.snp.makeConstraints { make in
            //make.top.equalTo(self.view).offset(50)
            make.centerY.equalTo(self.dateLabel)
            make.width.equalTo(30)
            make.height.equalTo(dateLabel)
            make.leading.equalTo(self.dateLabel.snp.trailing)
        }
        calendarAnimation.contentMode = .scaleAspectFill
        calendarAnimation.loopMode = .loop //무한 반복
        
        /// 캘린더 노출, 숨김 버튼
        self.view.addSubview(self.calendarShowHideBtn)
        self.calendarShowHideBtn.snp.makeConstraints { make in
            make.top.equalTo(self.calendarAnimation)
            make.width.equalTo(self.view).multipliedBy(0.35).offset(30)
            make.height.equalTo(self.calendarAnimation)
            make.leading.equalTo(self.dateLabel)
        }
        self.calendarShowHideBtn.addTarget(self, action: #selector(calendarShowHideAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.dateLabel)
            make.trailing.equalTo(self.view).offset(-10)
            make.height.equalTo(self.dateLabel).multipliedBy(1.5)
            make.width.equalTo(self.view).multipliedBy(0.3)
        }
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.titleLabel?.font = .systemFont(ofSize: 30)
        addBtn.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.calendarView)
        self.calendarView.backgroundColor = UIColor.blue
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.centerX.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0)
        }
        
        self.view.addSubview(self.todoListTableView)
        todoListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(10)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        todoListTableView.register(UINib(nibName: "TodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListTableViewCell")
        todoListTableView.showsVerticalScrollIndicator = false
        todoListTableView.isSkeletonable = true
        todoListTableView.rowHeight = 100
        todoListTableView.estimatedRowHeight = 100
        todoListTableView.separatorStyle = .none
        
    }
    
    // MARK: - 바텀 시트뷰 UI 작성
    func setBottomSheetUI() {
        
        self.bottomSheetViewController.view.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetViewController.view)
            make.centerX.equalTo(self.bottomSheetViewController.view)
            make.width.equalTo(self.bottomSheetViewController.view).multipliedBy(0.5)
            make.height.equalTo(self.bottomSheetViewController.view).multipliedBy(0.1)
        }
        bottomTitle.text = "일정 등록"
        bottomTitle.textAlignment = .center
        bottomTitle.adjustsFontSizeToFitWidth = true
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.bottomSheetViewController.view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetViewController.view)
            make.width.equalTo(self.bottomSheetViewController.view).multipliedBy(0.2)
            make.height.equalTo(bottomTitle)
            make.leading.equalTo(bottomTitle.snp.trailing).offset(self.bottomSheetViewController.view.frame.width * 0.05)
        }
        cancelBtn.setTitle("X", for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        cancelBtn.addTarget(self, action: #selector(bottomSheetDismiss(_:)), for: .touchUpInside)
        
        self.bottomSheetViewController.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomTitle.snp.bottom)
            make.width.equalTo(self.bottomSheetViewController.view)
            make.height.equalTo(self.bottomSheetViewController.view).multipliedBy(0.05)
            make.leading.equalTo(self.bottomSheetViewController.view).offset(30)
        }
        titleLabel.text = "목표 설정"
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetViewController.view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(self.bottomSheetViewController.view).multipliedBy(0.8)
        }
        titleTextField.placeholder = "할 일을 등록해 주세요."
        titleTextField.textColor = UIColor.black
        titleTextField.delegate = self
        
        self.bottomSheetViewController.view.addSubview(startDateLabel)
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
        
        self.bottomSheetViewController.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.bottomSheetViewController.view)
            make.height.equalTo(self.bottomSheetViewController.view).multipliedBy(0.18)
            make.width.equalTo(self.bottomSheetViewController.view).multipliedBy(0.8)
            make.top.equalTo(self.startDateLabel.snp.bottom)
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
            
        // datepicker 가 14로 넘어오면서 많이 변해서 분기처리
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //self.bottomSheetViewController.view.frame.height / 2 - self.bottomSheetViewController.view.frame.height * 0.27 - 20
        
        self.bottomSheetViewController.view.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.width.equalTo(self.bottomSheetViewController.view)
            make.centerX.equalTo(self.bottomSheetViewController.view)
            make.height.equalTo(self.bottomSheetViewController.view.frame.height / 2 - self.bottomSheetViewController.view.frame.height * 0.43 + 10)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("등록 하기", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        //bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoAddAction(_:)), for: .touchUpInside)
        
    }
    
    // MARK: - 키보드 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
