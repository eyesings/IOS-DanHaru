//
//  MainViewController+table.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/05.
//

import Foundation
import UIKit
import SkeletonView

extension MainViewController: UITableViewDataSource, UITableViewDelegate,SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.todoListModel?.model.count ?? 0
        return self.dummyData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TodoListTableViewCell.reusableIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.reusableIdentifier,
                                                       for: indexPath) as? TodoListTableViewCell
        else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        //FIXME: - 색상 확인
        if indexPath.row >= todoListCellBackGroundColor.count {
            cell.rounderView.backgroundColor = todoListCellBackGroundColor[indexPath.row - todoListCellBackGroundColor.count * (indexPath.row / todoListCellBackGroundColor.count)]
        } else {
            cell.rounderView.backgroundColor = todoListCellBackGroundColor[indexPath.row]
        }
        
        //cell.titleLabel.text = self.todoListModel.model[indexPath.row].title
        cell.titleLabel.text = self.dummyData[indexPath.row]
        cell.subLabel.text = "오늘, 인증 없음"
        cell.challengeTodoImgView.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = TodoListDetailViewController()
        
        detailVC.modalPresentationStyle = .fullScreen
        
//        detailVC.titleText = self.tableData[indexPath.row].title ?? "에러다!!"
        
        
       
        self.present(detailVC, animated: true, completion: nil)
        
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
