//
//  TodoListDetailViewController+collectionView.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/09.
//

import Foundation
import UIKit

extension TodoListDetailViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.detailInfoModel?.challenge_user?.count ?? 0
    }
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListDetailCollectionViewCell", for: indexPath) as! TodoListDetailCollectionViewCell
        
        
        cell.removeBorder(toSide: .Right)
        cell.personAuthBtn.setBackgroundImage(nil, for: .normal)
        cell.personAuthBtn.setTitle("재촉하기", for: .normal)
        
        if indexPath.item == 0 {
            cell.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 2.5)
        }
        
        cell.personImageView.contentMode = .scaleAspectFit
        
        cell.personAuthBtn.layer.borderWidth = 1.0
        cell.personAuthBtn.layer.borderColor = UIColor.black.cgColor
        cell.personAuthBtn.layer.cornerRadius = 10
        cell.personAuthBtn.tag = indexPath.item
        
        cell.personName.text = "이름"
        
        if cell.personAuthBtn.tag == 0 {
            cell.personAuthBtn.setTitle("", for: .normal)
            cell.personAuthBtn.setBackgroundImage(UIImage(named: "btnGreenCheck"), for: .normal)
            cell.personAuthBtn.isEnabled = false
            cell.personAuthBtn.layer.borderWidth = 0
            cell.checkTime.text = "\(DateFormatter().korDateString(date: Date(), dateFormatter: RadMessage.DateFormattor.timeDate)) 인증"
        }
        
        
        
        return cell
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
    
    
}
