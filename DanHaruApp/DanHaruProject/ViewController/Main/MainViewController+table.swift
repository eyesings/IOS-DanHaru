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
        return self.tableData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TodoListTableViewCell.reusableIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
        
        cell.selectionStyle = .none
        
        // 확인 필요
        if indexPath.row >= todoListCellBackGroundColor.count {
            cell.rounderView.backgroundColor = todoListCellBackGroundColor[indexPath.row - todoListCellBackGroundColor.count * (indexPath.row / todoListCellBackGroundColor.count)]
        } else {
            cell.rounderView.backgroundColor = todoListCellBackGroundColor[indexPath.row]
        }
        
        cell.titleLabel.text = self.tableData[indexPath.row].title
        cell.subLabel.text = "\(self.tableData[indexPath.row].date ?? Date())"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = TodoListDetailViewController()
        
        detailVC.modalPresentationStyle = .fullScreen
        
        detailVC.titleText = self.tableData[indexPath.row].title ?? "에러다!!"
        
        
       
        self.present(detailVC, animated: true, completion: nil)
        
    }
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    */
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: nil) { action, view, complection in
            self.tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            complection(true)
        }
        
        action.backgroundColor = .backgroundColor
        action.image = #imageLiteral(resourceName: "btnCloseUnSel")
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}
