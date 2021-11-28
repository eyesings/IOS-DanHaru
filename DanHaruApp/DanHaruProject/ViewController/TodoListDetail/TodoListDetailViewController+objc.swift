//
//  TodoListDetailViewController+objc.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/03.
//

import Foundation
import SnapKit
import UIKit
import AVFoundation

extension TodoListDetailViewController {
    
    /// 날짜 선택
    @objc func tapDateLabel(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            
            /// 시작 날짜 클릭
            if tag == DateLabelTag.startDateLabel.rawValue {
                
                let bottomVC = BottomSheetsViewController()
                bottomVC.modalPresentationStyle = .overFullScreen
                bottomVC.checkShowUI = BottomViewCheck.startDate.rawValue
                if let startDateText = self.startDateLabel.text {
                    bottomVC.preDate = startDateText
                }
                
                self.present(bottomVC, animated: true, completion: nil)

            } else if tag == DateLabelTag.endDateLabel.rawValue {
                
                let bottomVC = BottomSheetsViewController()
                bottomVC.modalPresentationStyle = .overFullScreen
                bottomVC.checkShowUI = BottomViewCheck.endDate.rawValue
                if let endDateText = self.endDateLabel.text {
                    bottomVC.preDate = endDateText
                }
                self.present(bottomVC, animated: true, completion: nil)
                
            }
        }
    }

    /// 반복주기 클릭 - 클릭시 [String] 에 추가(차후 수정)
    @objc func circleBtnAction(_ sender: UIButton) {
        
        if sender.tag == DayBtnTag.monday.rawValue {
            print("월")
            // 선택
            if sender.viewWithTag(DayBtnTag.monday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("월")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "월"}
            }
            
        } else if sender.tag == DayBtnTag.tuesday.rawValue {
            print("화")
            if sender.viewWithTag(DayBtnTag.tuesday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("화")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "화" }
            }
            
        } else if sender.tag == DayBtnTag.wednesday.rawValue {
            print("수")
            if sender.viewWithTag(DayBtnTag.wednesday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("수")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "수" }
            }
            
        } else if sender.tag == DayBtnTag.thursday.rawValue {
            print("목")
            if sender.viewWithTag(DayBtnTag.thursday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("목")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "목" }
            }
        
        } else if sender.tag == DayBtnTag.friday.rawValue {
            print("금")
            if sender.viewWithTag(DayBtnTag.friday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("금")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "금" }
            }
            
        } else if sender.tag == DayBtnTag.saturday.rawValue {
            print("토")
            if sender.viewWithTag(DayBtnTag.saturday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("토")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "토" }
            }

        } else if sender.tag == DayBtnTag.sunday.rawValue {
            print("일")
            if sender.viewWithTag(DayBtnTag.sunday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("일")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "일" }
            }
            
        } else if sender.tag == DayBtnTag.everyday.rawValue {
            print("매일")
            if sender.viewWithTag(DayBtnTag.everyday.rawValue)?.backgroundColor == .lightGrayColor {
                
                sender.backgroundColor = UIColor.darkGray
                sender.alpha = 1.0
                sender.setTitleColor(.white, for: .normal)
                self.circleCheckDay.append("매일")
            } else {
                // 선택해제
                sender.backgroundColor = .lightGrayColor
                sender.alpha = 0.5
                sender.setTitleColor(.black, for: .normal)
                self.circleCheckDay = self.circleCheckDay.filter { $0 != "매일" }
            }
            
        }
        
    }
    
    /// 뒤로가기
    @objc func backBtnAction(_ sender: UIButton) {
        
        if let deleteUrl = self.audioRecorder?.url {
            do {
                try FileManager.default.removeItem(at: deleteUrl)
            } catch _ {
                print("audioFile remove failed")
            }
        } else {
            print("audioRecorder url nil")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    /// 반복주기 시간 선택
    @objc func circleTimeLabelAction(_ tapGesture: UITapGestureRecognizer) {
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.cycleTime.rawValue
        // 선택한 시간을 넘겨줘야함
        
        self.present(bottomVC, animated: true, completion: nil)
        
    }
    
    /// 오디오 버튼 클릭
    @objc func audioAuth(_ sender:UIButton) {
        
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.audioRecord.rawValue
        bottomVC.defaultHeight = self.view.frame.height / 3
        bottomVC.delegate = self
        self.present(bottomVC, animated: true, completion: nil)
    }
    
    /// 이미지 버튼 클릭
    @objc func photoAlbumAuth(_ sender: UIButton) {
        
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    /// 이미지 삭제 버튼 클릭후 UI 변경
    @objc func deleteAuthImage(_ sender: UIButton) {
        
        if sender.tag == ImageDeleteBtnTag.deleteImageView1.rawValue {
            
            authImageView1.snp.remakeConstraints { make in
                make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.left.equalTo(self.view)
            }
            self.authImageView1.image = nil
            
            if authImageView2.image != nil {
                authImageView2.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
                }
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    
                    make.top.equalTo(self.authImageView2.snp.bottom).offset(25)
                    make.width.equalTo(self.view).multipliedBy(0.5)
                    make.leading.equalTo(self.authLable)
                    make.height.equalTo(self.authLable)
                    
                }
                
            }
            
            if authImageView2.image == nil && authImageView3.image != nil {
                
                authImageView3.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
                }
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    
                    make.top.equalTo(self.authImageView3.snp.bottom).offset(25)
                    make.width.equalTo(self.view).multipliedBy(0.5)
                    make.leading.equalTo(self.authLable)
                    make.height.equalTo(self.authLable)
                    
                }
                
            }
            
        } else if sender.tag == ImageDeleteBtnTag.deleteImageView2.rawValue {
            
            authImageView2.snp.remakeConstraints { make in
                make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.left.equalTo(self.view)
            }
            
            self.authImageView2.image = nil
            
            if authImageView3.image !=  nil {
                
                if authImageView2.image == nil && authImageView1.image == nil {
                    
                    authImageView3.snp.remakeConstraints { make in
                        make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                        make.width.equalTo(self.view).multipliedBy(0.22)
                        make.height.equalTo(self.view.frame.width * 0.22)
                        make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
                    }
                    
                } else {
                    authImageView3.snp.remakeConstraints { make in
                        make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                        make.width.equalTo(self.view).multipliedBy(0.22)
                        make.height.equalTo(self.view.frame.width * 0.22)
                        make.left.equalTo(authImageView1.snp.right).offset(self.view.frame.width * 0.02)
                    }
                    
                }
                
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    
                    make.top.equalTo(self.authImageView3.snp.bottom).offset(25)
                    make.width.equalTo(self.view).multipliedBy(0.5)
                    make.leading.equalTo(self.authLable)
                    make.height.equalTo(self.authLable)
                    
                }
                
                
            }
            
            
            
        } else if sender.tag == ImageDeleteBtnTag.deleteImageView3.rawValue {
            
            authImageView3.snp.remakeConstraints { make in
                make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.left.equalTo(self.view)
            }
            
            self.authImageView3.image = nil
            
            if self.authImageView1.image != nil {
                togetherFriendLabel.snp.remakeConstraints { make in
                    make.top.equalTo(self.authImageView1.snp.bottom).offset(25)
                    make.width.equalTo(self.view).multipliedBy(0.5)
                    make.leading.equalTo(self.authLable)
                    make.height.equalTo(self.authLable)
                    
                }
            }
            
        }
        
        // 함께 도전 라벨, 모든 이미지가 존재 하지 않을 시
        if authImageView1.image == nil && authImageView2.image == nil && authImageView3.image == nil {
            self.isImageAuth = false
            togetherFriendLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.authImageView1.snp.bottom).offset(25)
                make.width.equalTo(self.view).multipliedBy(0.5)
                make.leading.equalTo(self.authLable)
                make.height.equalTo(self.authLable)
            }
            
        }
        
    }
    
    @objc func updatePlayTime() {
        if let player = self.audioPlayer {
            self.audioProgressBar.progress = Float(player.currentTime / player.duration )
        } else {
            print("player nil")
        }
    }
    
    @objc func audioDeleteButtonAction(_ sender: UIButton) {
        
        RadAlertViewController.alertControllerShow(WithTitle: "알림", message: "정말로 삭제하시겠습니까?", isNeedCancel: true, viewController: self) { check in
            
            if check {
                
                if let deleteUrl = self.audioRecorder?.url {
                    do {
                        try FileManager.default.removeItem(at: deleteUrl)
                    } catch _ {
                        print("audioFile remove failed")
                    }
                } else {
                    print("audioRecorder url nil")
                }
                
            }
            
        }
        
        self.progressTimer.invalidate()
        
    }
    
    @objc func audioPlayStopButtonAction(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage(named: "btnPlay") {
            
            if let recorder = self.audioRecorder {
                
                self.audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                
                if let player = self.audioPlayer {
                    player.delegate = self
                    player.play()
                    progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
                    sender.setImage(#imageLiteral(resourceName: "btnPause"), for: .normal)
                } else {
                    print("player nil error")
                }
                
            }
            
            
        } else {
            if let recorder = self.audioRecorder {
                self.audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                if let player = self.audioPlayer {
                    player.delegate = self
                    player.pause()
                    sender.setImage(#imageLiteral(resourceName: "btnPlay"), for: .normal)
                }
                
            }
            
        }
        
    }
    
    @objc func applicationWillTerminate(_ notification:UNNotification) {
        
        if let recorder = self.audioRecorder {
            
            do {
                try FileManager.default.removeItem(at: recorder.url)
            } catch _ {
                print("TodoListDetailView audio file remove failed")
            }
            
        }
        
    }
    
}
