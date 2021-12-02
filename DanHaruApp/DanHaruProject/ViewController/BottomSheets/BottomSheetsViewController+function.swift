//
//  BottomSheetsViewController+function.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/03.
//

import Foundation
import SnapKit
import UIKit
import AVFoundation

extension BottomSheetsViewController {
    
    //MARK: - 바텀 뷰 보이기, 숨기기 함수
    /// 바텀 뷰 화면 노출
    func showBottomSheet() {
        
        let safeAreaHeight:CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding:CGFloat = view.safeAreaInsets.bottom
        
        let constant = (safeAreaHeight + bottomPadding) - self.defaultHeight
        self.bottomSheetView.snp.remakeConstraints { make in
            make.top.equalTo(self.view).offset(constant)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            //self.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: constant)
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
            
        } completion: { (_) in
            
        }
    }
    
    /// 바텀 시트 뷰 숨김
    func hideBottomSheetAndGoBack() {
        //let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        //let bottomPadding = view.safeAreaInsets.bottom
        //bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        // 오디오 녹음이 끝나지 않고 화면 dismiss(생성된 오디오 파일 삭제)
        if !self.isBottomToCheck && self.checkShowUI == BottomViewCheck.audioRecord.rawValue {
            if let url = self.audioRecorder?.url {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch _ {
                    print("audio file remove failed")
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if self.presentingViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: - 기본 함수
    /// 날짜 변환 String -> Date
    func getStringToDate(_ date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        var convertDate = format.date(from: date)
        convertDate?.addTimeInterval(32400)
        
        guard let result = convertDate else { return Date() }
        
        return result
    }
    
    //MARK: - 키보드 관련 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
}
