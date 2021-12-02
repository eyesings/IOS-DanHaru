//
//  MainViewController+Init.swift
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
        dateLabel.text = DateFormatter().korDateString(dateFormatter: RadMessage.DateFormattor.monthDate)
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
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(self.dateLabel)
            make.trailing.equalTo(self.todoAddBtn)
            make.height.equalTo(0)
        }
        
        calendar = CalendarView(frame: calendarView.frame)
        calendar.delegate = self
        calendar.dataSource = self
        calendarView.addSubview(calendar)
        
        calendar.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(calendarView)
        }
        
        /// 투두 테이블 뷰
        self.view.addSubview(self.todoListTableView)
        todoListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom)
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
        
        todoListTableView.addSubview(cautionView)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(onTappedBtn), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func onTappedBtn() {
        let inviteMemId = "djaaksmscjs"
        let todoIdx = 23
        
        _ = TodoDetailViewModel.init(todoIdx, selectedDate) { model in
            let detailVC = TodoListDetailViewController()
            detailVC.detailInfoModel = model
            detailVC.isForInviteFriend = true
            detailVC.invitedMemId = inviteMemId
            self.navigationController?.pushViewController(detailVC)
        }
    }
    
    internal func calendarViewAnimation() {
        
        UIView.animate(withDuration: 0.3) {
            self.calendarView.snp.updateConstraints { make in
                make.height.equalTo(self.calendarShowOn ? 0 :screenwidth * 0.8)
            }
            self.calendarView.superview?.layoutIfNeeded()
        }
        
    }
    
    internal func showNoneListView(_ isSuccess: Bool) {
        
        cautionView.isHidden = isSuccess
        cautionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.todoListTableView)
        }
        
        let infoLabel = UILabel()
        infoLabel.font = .boldSystemFont(ofSize: 25.0)
        infoLabel.text = RadMessage.Main.noneTodoListInfo
        infoLabel.textColor = .customBlackColor
        infoLabel.textAlignment = .center
        cautionView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cautionView.snp.centerY)
            make.centerX.equalTo(cautionView)
            make.width.equalTo(cautionView).multipliedBy(0.9)
            make.height.equalTo(cautionView).multipliedBy(0.05)
        }
        
        let detailInfoLabel = UILabel()
        detailInfoLabel.font = .systemFont(ofSize: screenwidth * 0.04)
        detailInfoLabel.numberOfLines = 0
        detailInfoLabel.text = RadMessage.Main.noneTodoListSubInfo
        detailInfoLabel.textColor = .heavyGrayColor
        detailInfoLabel.textAlignment = .center
        cautionView.addSubview(detailInfoLabel)
        
        detailInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(cautionView.snp.centerY)
            make.centerX.width.equalTo(infoLabel)
            make.height.equalTo(screenheight * 0.1)
        }
        
        let animateView = AnimationView(name: "idea")
        animateView.play()
        animateView.loopMode = .playOnce
        animateView.contentMode = .scaleAspectFit
        animateView.animationSpeed = 1.3
        cautionView.addSubview(animateView)
        
        animateView.snp.makeConstraints { make in
            make.centerX.equalTo(cautionView)
            make.bottom.equalTo(infoLabel.snp.top)
            make.width.equalTo(cautionView).multipliedBy(0.5)
            make.height.equalTo(animateView.snp.width)
        }
        
        
        let dynamicSize = screenwidth * 0.045
        let addTodoBtn = UIButton()
        addTodoBtn.backgroundColor = .subHeavyColor
        addTodoBtn.setTitle(RadMessage.Main.noneTodoListAddTodo, for: .normal)
        addTodoBtn.setTitleColor(.backgroundColor, for: .normal)
        addTodoBtn.titleLabel?.font = .systemFont(ofSize: dynamicSize)
        addTodoBtn.layer.cornerRadius = dynamicSize * 1.2
        addTodoBtn.addTarget(self, action: #selector(self.addAction), for: .touchUpInside)
        cautionView.addSubview(addTodoBtn)
        
        addTodoBtn.snp.makeConstraints { make in
            make.top.equalTo(detailInfoLabel.snp.bottom)
            make.centerX.equalTo(infoLabel)
            make.width.equalTo(infoLabel).multipliedBy(0.6)
            make.height.equalTo(addTodoBtn.snp.width).multipliedBy(0.2)
        }
    }
}
