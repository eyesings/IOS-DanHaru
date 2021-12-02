//
//  BottomSheetsViewController+objc.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/26.
//

import UIKit
import SnapKit
import Lottie
import AVFoundation


extension BottomSheetsViewController {
    
    //MARK: - 바텀 뷰 조절 함수
    /// 바텀 딤 부분 터치
    @objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    /// 바텀 높이 조절
    @objc func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.velocity(in: view)
        
        //print("유저가 위아래로 : \(translation.y) : 만큼 드래그")
        //print("속도 \(velocity.y)")
        /*
        if velocity.y > 1500 {
            hideBottomSheetAndGoBack()
            return
        }
        */
       
        let safeAreaHeight:CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding:CGFloat = view.safeAreaInsets.bottom
        
        if translation.y > 0 {
            
            switch panGestureRecognizer.state {
                case .began:
                    //bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
                    //bottomSheetPanStartingTopConstant = safeAreaHeight + bottomPadding - defaultHeight
                    break
                case .changed:
                    
                    //bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
                    bottomSheetView.snp.remakeConstraints { make in
                        make.top.equalTo(self.view).offset(safeAreaHeight + bottomPadding - defaultHeight + translation.y)
                        make.leading.equalTo(self.view)
                        make.trailing.equalTo(self.view)
                        make.height.equalTo(self.view)
                    }
                    
                    if abs(velocity.y) > 1500 {
                        hideBottomSheetAndGoBack()
                        return
                    }
                    
                    // 이유는 모르나 빠른 스크롤시 ended 로 넘어가지 않음
                    // velocity 로 if 절로 한번더 체크??
            
                case .ended:
                    print("드래그가 끝남")
                    
                    if translation.y >= self.view.frame.height / 3 {
                        hideBottomSheetAndGoBack()
                        return
                    }
                    
                    showBottomSheet()
                    
                default:
                    break
            }
        }
        
    }
    
    /// 바텀 뷰 숨김
    @objc func bottomSheetDismiss(_ sender: UIButton) {
        self.hideBottomSheetAndGoBack()
    }
    
}
