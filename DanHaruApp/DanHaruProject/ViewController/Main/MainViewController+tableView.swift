//
//  MainViewController+tableView.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/25.
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
        
        // 확인 필요
        if indexPath.row >= Configs.todoListCellBackGroundColor.count {
            cell.rounderView.backgroundColor = Configs.todoListCellBackGroundColor[indexPath.row - Configs.todoListCellBackGroundColor.count * (indexPath.row / Configs.todoListCellBackGroundColor.count)]
        } else {
            cell.rounderView.backgroundColor = Configs.todoListCellBackGroundColor[indexPath.row]
        }
        
        /*
        let number = Int.random(in: 0...3)
        
        cell.rounderView.backgroundColor = Configs.todoListCellBackGroundColor[number]
        */
        
        
        cell.titleLabel.text = self.tableData[indexPath.row]
        cell.subLabel.text = "\(Date())"
        
        
        return cell
    }
    
    
}
