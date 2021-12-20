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
        return self.detailInfoModel?.challenge_user?.count ?? 10
    }
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionViewType = DetailCollectionViewTag.init(rawValue: collectionView.tag) else { return UICollectionViewCell() }
        
        if collectionViewType == .challFriend {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeFriendCollectionViewCell.reusableIdentifier,
                                                                for: indexPath) as? ChallengeFriendCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.profileImg.image = UIImage(named: "profileNon")
            
            return cell
            
        } else if collectionViewType == .currAuth {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListDetailCollectionViewCell", for: indexPath) as! TodoListDetailCollectionViewCell
            
            if indexPath.item == 0 {
                // FIXME: 첫번째에 로그인한 유저가 오게끔 이외 순서 상관없음
            }
            
            cell.personAuthBtn.tag = indexPath.item
            
            cell.personName.text = "이름"
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
    /*
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.todayAuthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        var offset = targetContentOffset.pointee
        
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        print("방향 \(actualPosition)")
        
        if actualPosition.x < 0 {
            self.currentIdx += 1
        } else {
            if self.currentIdx != 0 {
                self.currentIdx -= 1
            }
        }
        
        offset = CGPoint(x: (layout.itemSize.width * 3 * self.currentIdx).rounded(.up) , y: -scrollView.contentInset.top)
        
        print("위치 \(layout.itemSize.width * 5 * self.currentIdx)")
        
        targetContentOffset.pointee = offset
        
        
    }
    */
    
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
