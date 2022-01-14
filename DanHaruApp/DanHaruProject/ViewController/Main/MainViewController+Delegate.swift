//
//  MainViewController+Delegate.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/05.
//

import Foundation
import UIKit
import SkeletonView

extension MainViewController: UITableViewDataSource, UITableViewDelegate,SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoListModel?.model.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TodoListTableViewCell.reusableIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.reusableIdentifier,
                                                       for: indexPath) as? TodoListTableViewCell,
              let todoTitle = self.todoListModel.model[indexPath.row].encodedTitle
        else { return UITableViewCell() }
        
        let todoModel = self.todoListModel.model[indexPath.row]
        cell.selectionStyle = .none
        
        if let colorCode = todoModel.color {
            cell.rounderView.backgroundColor = RadHelper.colorFromHex(hex: colorCode)
        } else {
            cell.rounderView.backgroundColor = .mainColor
        }
        
        cell.titleLabel.text = todoTitle
        cell.subLabel.text = "인증 \(todoModel.certi_yn?.lowercased() == "y" ? "완료" : "없음")"
        cell.challengeTodoImgView.isHidden = todoModel.chaluser_yn?.lowercased() == "y" ? false : true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIdxPath = indexPath
        self.apiService(withType: .TodoDetail)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let createUser = self.todoListModel.model[indexPath.row].created_user,
              let todoIdx = self.todoListModel.model[indexPath.row].todo_id,
              UserModel.memberId == createUser
        else { return UISwipeActionsConfiguration() }
        
        let action = UIContextualAction(style: .normal, title: nil) { action, View, complection in
            _ = TodoDeleteViewModel.init(todoIdx: todoIdx, completionHandler: {
                self.apiService(withType: .TodoList)
                complection(true)
            }, errHandler: { print(("error \($0)")) })
        }
        
        let actionSize = screenwidth * 0.13
        action.backgroundColor = .backgroundColor
        action.image = UIGraphicsImageRenderer(size: CGSize(width: actionSize, height: actionSize)).image { _ in
            UIImage(named: "btnCloseSel")!.draw(in: CGRect(x: -10, y: 0, width: actionSize, height: actionSize))
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}


extension MainViewController: CalendarViewDelegate, CalendarViewDataSource {
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = -12
        
        let today = Date()
        
        return self.calendar.calendar.date(byAdding: dateComponents, to: today)!
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.month = 12
        let today = Date()
        
        return self.calendar.calendar.date(byAdding: dateComponents, to: today)!
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date) {
        
        print("Did Select: \(date)")
        
        guard let rootVC = RadHelper.getRootViewController() else { return }
        rootVC.showLoadingView()
        
        selectedDate = DateFormatter().korDateString(date: date)
        self.dateLabel.text = DateFormatter().korDateString(date: date, dateFormatter: RadMessage.DateFormattor.monthDate)
        self.apiService(withType: .TodoList)
        self.calendarShowHideAction()
    }
}
