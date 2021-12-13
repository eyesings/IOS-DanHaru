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
    /// 수정시 수정사항 공유 필수 ******
    @objc func onTapDayNotiBtn(_ sender: UIButton) {
        
        guard let selectedTag = DetailNotiDayBtnTag.init(rawValue: sender.tag) else { return }
        if selectedTag == .everyday {
            self.selectedNotiDay.removeAll()
            for btn in self.selectedNotiBtnList {
                guard let btnTag = DetailNotiDayBtnTag.init(rawValue: btn.tag) else { return }
                
                btn.isSelected = !sender.isSelected
                btn.backgroundColor = btn.isSelected ? .mainColor : .lightGrayColor
                
                if btn.isSelected {
                    self.selectedNotiDay.append(btnTag.name())
                } else {
                    self.selectedNotiDay = self.selectedNotiDay.filter { $0 != btnTag.name() }
                }
                
                
            }
            print("selectedNotiDay \(self.selectedNotiDay)")
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = sender.isSelected ? .mainColor : .lightGrayColor
        
        if sender.isSelected {
            self.selectedNotiDay.append(selectedTag.name())
        } else {
            
            for btn in self.selectedNotiBtnList {
                guard let btnTag = DetailNotiDayBtnTag.init(rawValue: btn.tag) else { return }
                if btnTag == .everyday {
                    btn.isSelected = false
                    btn.backgroundColor = btn.isSelected ? .mainColor : .lightGrayColor
                    self.selectedNotiDay = self.selectedNotiDay.filter { $0 != btnTag.name()}
                }
            }
            
            self.selectedNotiDay = self.selectedNotiDay.filter { $0 != selectedTag.name() }
        }
        
        print("selectedNotiDay \(self.selectedNotiDay)")
    }
    
    @objc func onTapSubmitBtn() {
        guard let todoModel = self.detailInfoModel,
              let inviteMemId = self.invitedMemId,
              let mainVC = RadHelper.getMainViewController() as? MainViewController
        else { return }
        
        func reloadMainListView() {
            self.navigationController?.popViewController()
            mainVC.requestTodoList(NSNotification(name: Notification.Name.init(rawValue: ""), object: true))
        }
        
        _ = TodoDetailUpdateViewModel.init(todoModel, notiCycle: nil, notiTime: nil) {
            if self.isForInviteFriend {
                _ = TodoCreateChallengeViewModel.init(todoModel.todo_id!, inviteMemId) {
                    reloadMainListView()
                } errHandler: { Dprint("error \($0)") }
            } else {
                reloadMainListView()
            }
        } errHandler: { Dprint("type \($0)") }
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
        self.navigationController?.popViewController()
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
        //bottomVC.defaultHeight = self.view.frame.height / 2.8
        bottomVC.defaultHeight = 280
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
                
                checkAnimation.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView2.snp.bottom).offset(10)
                    make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(self.view.frame.width * 0.25)
                }
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    
                    make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
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
                
                checkAnimation.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView3.snp.bottom).offset(10)
                    make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(self.view.frame.width * 0.25)
                }
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    
                    make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
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
                
                checkAnimation.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView3.snp.bottom).offset(10)
                    make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(self.view.frame.width * 0.25)
                }
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    
                    make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
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
                
                checkAnimation.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView1.snp.bottom).offset(10)
                    make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(self.view.frame.width * 0.25)
                }
                
                togetherFriendLabel.snp.remakeConstraints { make in
                    make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
                    make.width.equalTo(self.view).multipliedBy(0.5)
                    make.leading.equalTo(self.authLable)
                    make.height.equalTo(self.authLable)
                    
                }
            }
            
        }
        
        // 함께 도전 라벨, 모든 이미지가 존재 하지 않을 시
        if authImageView1.image == nil && authImageView2.image == nil && authImageView3.image == nil {
            self.isImageAuth = false
            
            checkAnimation.snp.remakeConstraints { make in
                make.top.equalTo(authImageView1.snp.bottom).offset(10)
                make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                make.centerX.equalTo(self.view)
                make.height.equalTo(self.view.frame.width * 0.25)
            }
            
            togetherFriendLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
                make.width.equalTo(self.view).multipliedBy(0.5)
                make.leading.equalTo(self.authLable)
                make.height.equalTo(self.authLable)
            }
            
        }
        
    }
    
    @objc func audioDeleteButtonAction(_ sender: UIButton) {
        
        RadAlertViewController.alertControllerShow(WithTitle: "알림", message: "정말로 삭제하시겠습니까?", isNeedCancel: true, viewController: self) { check in
            
            if check {
                
                if let deleteUrl = self.audioRecorder?.url {
                    do {
                        try FileManager.default.removeItem(at: deleteUrl)
                        
                        self.audioPlayArea.snp.remakeConstraints { make in
                            make.top.equalTo(self.authCheckBtn.snp.bottom).offset(25)
                            make.width.equalTo(self.view).multipliedBy(0.8)
                            make.height.equalTo(0)
                            make.centerX.equalTo(self.view)
                        }
                        
                        
                    } catch _ {
                        print("audioFile remove failed")
                    }
                } else {
                    print("audioRecorder url nil")
                }
                
            }
            
        }
        
        if self.audioPlayer != nil {
            self.progressTimer.invalidate()
        }
        
    }
    
    @objc func audioPlayStopButtonAction(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage(named: "btnPlayCircle") {
            
            if let recorder = self.audioRecorder {
                
                self.audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                
                if let player = self.audioPlayer {
                    player.delegate = self
                    player.play()
                    progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
                    sender.setImage(UIImage(named: "btnPauseCircle"), for: .normal)
                    
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
                    sender.setImage(UIImage(named: "btnPlayCircle"), for: .normal)
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
    
    /// 오디오 녹음 시간 체크
    @objc func updateRecordTime() {
        
        if let player = self.audioPlayer {
            self.audioPlayTimeText.text = RadHelper.convertNSTimeInterval12String(player.currentTime)
        }
        
    }
    
    /// 단순 체크 인증
    @objc func authCheckButtonAction(_ sender: UIButton) {
        self.checkAnimation.snp.remakeConstraints { make in
            make.top.equalTo(authImageView1.snp.bottom).offset(10)
            make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
            make.centerX.equalTo(self.view)
            make.height.equalTo(self.view.frame.width * 0.25)
        }
        
        if !self.isCheckAuth {
            checkAnimation.play()
            self.isCheckAuth = true
        } else {
            RadAlertViewController.alertControllerShow(WithTitle: RadMessage.basicTitle, message: "인증을 취소하시겠습니까?", isNeedCancel: true, viewController: self) { check in
                
                if check {
                    self.isCheckAuth = false
                    self.checkAnimation.snp.remakeConstraints { make in
                        make.top.equalTo(self.authImageView1.snp.bottom).offset(10)
                        make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                        make.centerX.equalTo(self.view)
                        make.height.equalTo(0)
                    }
                    self.checkAnimation.play(toFrame: 0)
                }
                
            }
        }
        
        
        
    }
    
}
