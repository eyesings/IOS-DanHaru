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
        else if collectionViewType == .currAuth { return (self.detailInfoModel?.challenge_user?.count ?? 0) + 1}
        else { return self.detailInfoModel?.challenge_user?.count ?? 0 }
        
    }
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return UICollectionViewCell() }
        
        if collectionViewType == .challFriend {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeFriendCollectionViewCell.reusableIdentifier,
                                                                for: indexPath) as? ChallengeFriendCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.profileImg.image = UIImage(named: "profileNon")
            
            cell.profileName.text = self.detailInfoModel?.challenge_user?[indexPath.item].mem_id ?? "초대된 유저 이름"
            
            return cell
            
        } else if collectionViewType == .currAuth {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListDetailCollectionViewCell", for: indexPath) as! TodoListDetailCollectionViewCell
            
            cell.personName.text = ""
            
            if indexPath.item == 0 {
                // FIXME: 첫번째에 로그인한 유저가 오게끔 이외 순서 상관없음
                cell.personAuthBtn.tag = indexPath.item
                cell.personName.text = self.detailInfoModel?.mem_id ?? "로그인한 계정 이름"
                
            } else {
                cell.personAuthBtn.tag = indexPath.item
                
                cell.personName.text = self.detailInfoModel?.challenge_user?[indexPath.item - 1].mem_id ?? "추가된 계정들 이름"
                
            }
            
            cell.authUserChangeUI(cell.personAuthBtn.tag == 0)
            
            return cell
        } else if collectionViewType == .imgAuth {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAuthShowCollectionViewCell", for: indexPath) as? ImageAuthShowCollectionViewCell
            else { return UICollectionViewCell() }
            cell.authImage.image = self.selectedImage[indexPath.item]
            cell.onTapDeleteBtn = {
                self.selectedImage.remove(at: indexPath.item)
                if self.selectedImage.count == 0 {
                    self.regiAuthUpdate(isShow: false)
                    self.authImageCollectionView.isHidden = true
                    self.isRegisterAuth = false
                }
                collectionView.reloadData()
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return .zero }
        let collectionViewHeight = collectionView.frame.height
        if collectionViewType == .challFriend {
            return CGSize(width: collectionViewHeight * 0.7, height: collectionViewHeight * 0.7)
        } else if collectionViewType == .currAuth {
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
        if collectionViewType == .challFriend {
            return screenwidth * 0.06
        } else if collectionViewType == .imgAuth {
            return screenwidth * 0.01
        } else {
            return 0
        }
    }
}
