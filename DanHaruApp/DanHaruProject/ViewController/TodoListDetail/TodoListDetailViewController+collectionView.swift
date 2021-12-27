//
//  TodoListDetailViewController+collectionView.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/09.
//

import Foundation
import UIKit

extension TodoListDetailViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return 0 }
        if collectionViewType == .imgAuth { return self.selectedImage.count }
        else if collectionViewType == .currAuth { return (self.detailInfoModel.challenge_user?.count ?? 0) + 1}
        else { return self.detailInfoModel.challenge_user?.count ?? 0 }
        
    }
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return UICollectionViewCell() }
        
        if collectionViewType == .currAuth {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListDetailCollectionViewCell", for: indexPath) as? TodoListDetailCollectionViewCell
            else { return UICollectionViewCell() }
            
            
            cell.personName.text = ""
            cell.todoIdx = self.detailInfoModel?.todo_id ?? 0
            cell.todoTitle = self.titleTextField.text ?? ""
            //cell.authUserChangeUI(cell.personAuthBtn.tag == 0)
            
            cell.personAuthBtn.tag = indexPath.item
            // 오늘 인증 현황
            guard let list = self.detailInfoModel.certification_list else {
                print("certification list nil")
                return cell
            }
            
            return self.createCurrAuthCell(list, indexPath, cell)
        } else if collectionViewType == .imgAuth {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAuthShowCollectionViewCell", for: indexPath) as? ImageAuthShowCollectionViewCell
            else { return UICollectionViewCell() }
            cell.authImage.image = self.selectedImage[indexPath.item]
            //MARK: 오늘 인증 내역 존재시 이미지 삭제 차단
            if self.isCurrAuth {
                cell.deleteBtn.isHidden = true
            } else {
                cell.onTapDeleteBtn = {
                    self.selectedImage.remove(at: indexPath.item)
                    if self.selectedImage.count == 0 {
                        self.regiAuthUpdate(isShow: false)
                        self.authImageCollectionView.isHidden = true
                        self.isRegisterAuth = false
                    }
                    collectionView.reloadData()
                }
            }
            
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return .zero }
        let collectionViewHeight = collectionView.frame.height
        if collectionViewType == .currAuth {
            return CGSize(width: screenwidth * 0.4, height: collectionViewHeight * 0.9)
        } else if collectionViewType == .imgAuth {
            return CGSize(width: collectionViewHeight * 0.8, height: collectionViewHeight * 0.8)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return .zero }
        if collectionViewType == .imgAuth {
            let cellWidth = Int(collectionView.frame.height * 0.8)
            let cellCount = collectionView.numberOfItems(inSection: 0)
            let totalCellWidth = cellWidth * cellCount
            let totalSpacingWidth = (Int(screenwidth * 0.01)) * (collectionView.numberOfItems(inSection: 0) - 1)

            let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset

            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return 0.0 }
        if collectionViewType == .imgAuth {
            return screenwidth * 0.01
        } else {
            return 0
        }
    }
    
    
}
