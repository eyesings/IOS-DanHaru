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
        
        let pagePadding = screenwidth * 0.05
        
        self.view.addSubview(dateLabel)
        Configs.formatter.dateFormat = "MM월 dd일"
        let current_date_string = Configs.formatter.string(from: Date())
        dateLabel.text = current_date_string
        dateLabel.textAlignment = .left
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = .boldSystemFont(ofSize: screenwidth * 0.08)
        dateLabel.minimumScaleFactor = pagePadding
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(screenwidth * 0.1)
            make.leading.equalTo(self.view).offset(screenwidth * 0.08)
            make.height.equalTo(50)
        }
        dateLabel.sizeToFit()
        
        /// 아래 버튼, 캘린더 노출
        self.view.addSubview(calendarAnimation)
        calendarAnimation.snp.makeConstraints { make in
            make.centerY.height.equalTo(self.dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing)
            make.width.equalTo(screenwidth * 0.08)
        }
        calendarAnimation.contentMode = .scaleAspectFill
        calendarAnimation.loopMode = .loop
        
        /// 캘린더 노출, 숨김 버튼
        self.view.addSubview(calendarShowHideBtn)
        calendarShowHideBtn.snp.makeConstraints { make in
            make.trailing.equalTo(calendarAnimation)
            make.leading.top.bottom.equalTo(dateLabel)
        }
        calendarShowHideBtn.addTarget(self, action: #selector(calendarShowHideAction(_:)), for: .touchUpInside)
        
        /// 할일 추가
        self.view.addSubview(todoAddBtn)
        todoAddBtn.snp.makeConstraints { make in
            make.trailing.equalTo(self.view).offset(-pagePadding)
            make.top.bottom.equalTo(dateLabel)
            make.width.equalTo(todoAddBtn.snp.height)
        }
        todoAddBtn.setImage(UIImage(named: "btnAdd"), for: .normal)
        todoAddBtn.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        
        /// 캘린더 뷰
        self.view.addSubview(calendarView)
        calendarView.backgroundColor = UIColor.blue
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(self.dateLabel)
            make.trailing.equalTo(self.todoAddBtn)
            make.height.equalTo(0)
        }
        
        /// 투두 테이블 뷰
        self.view.addSubview(self.todoListTableView)
        todoListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalTo(self.view)
        }
        todoListTableView.backgroundColor = .backgroundColor
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        todoListTableView.register(UINib(nibName: TodoListTableViewCell.reusableIdentifier, bundle: nil),
                                   forCellReuseIdentifier: TodoListTableViewCell.reusableIdentifier)
        todoListTableView.showsVerticalScrollIndicator = false
        todoListTableView.isSkeletonable = true
        todoListTableView.rowHeight = 90
        todoListTableView.separatorStyle = .none
    }
    
    internal func calendarViewAnimation() {
        
        UIView.animate(withDuration: 0.3) {
            self.calendarView.snp.updateConstraints { make in
                make.height.equalTo(self.calendarShowOn ? 0 :screenwidth * 0.9)
            }
            self.calendarView.superview?.layoutIfNeeded()
        }
        
    }
    
    internal func showNoneListView() {
        let cautionView = UIView()
        cautionView.backgroundColor = .systemBlue
        self.view.addSubview(cautionView)
        
        cautionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        }
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
