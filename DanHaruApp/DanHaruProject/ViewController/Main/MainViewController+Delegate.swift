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
              let todoTitle = self.todoListModel.model[indexPath.row].title
        else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        //FIXME: - 색상 확인
        if indexPath.row >= todoListCellBackGroundColor.count {
            cell.rounderView.backgroundColor = todoListCellBackGroundColor[indexPath.row - todoListCellBackGroundColor.count * (indexPath.row / todoListCellBackGroundColor.count)]
        } else {
            cell.rounderView.backgroundColor = todoListCellBackGroundColor[indexPath.row]
        }
        
        cell.titleLabel.text = todoTitle
//        cell.titleLabel.text = self.dummyData[indexPath.row]
        cell.subLabel.text = "오늘, 인증 없음"
        cell.challengeTodoImgView.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = TodoListDetailViewController()
        
        detailVC.modalPresentationStyle = .fullScreen
        
//        detailVC.titleText = self.tableData[indexPath.row].title ?? "에러다!!"
        
//        self.present(detailVC, animated: true, completion: nil)
        /*
        let _ = TodoDetailViewModel(1, "2021-12-07") { model in
            detailVC.todoModel = model
            
            self.navigationController?.pushViewController(detailVC)
        }
        */
        self.navigationController?.pushViewController(detailVC)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: nil) { action, View, complection in
//            self.tableData.remove(at: indexPath.row)
            // FIXME: model 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            complection(true)
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
        dateComponents.month = -3
        
        let today = Date()
        
        return self.calendar.calendar.date(byAdding: dateComponents, to: today)!
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.month = 5
        let today = Date()
        
        return self.calendar.calendar.date(byAdding: dateComponents, to: today)!
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date) {
        
        print("Did Select: \(date)")
        
        guard let rootVC = RadHelper.getRootViewController() else { return }
        rootVC.showLoadingView()
        
        let selectedDateStr = DateFormatter().korDateString(date: date)
        selectedDate = selectedDateStr
        self.dateLabel.text = DateFormatter().korDateString(date: date, dateFormatter: RadMessage.DateFormattor.monthDate)
        self.todoListModel = TodoListViewModel.init(searchDate: selectedDateStr)
    }
}
