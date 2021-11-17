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
        return 15
    }
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListDetailCollectionViewCell", for: indexPath) as! TodoListDetailCollectionViewCell
        
        cell.personImageView.contentMode = .scaleAspectFit
        
        cell.personName.text = "\(indexPath.item)"
        
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
