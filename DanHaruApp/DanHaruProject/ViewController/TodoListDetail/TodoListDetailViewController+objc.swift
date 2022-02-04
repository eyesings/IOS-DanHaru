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
import MessageUI
import FirebaseMessaging


extension TodoListDetailViewController {
    
    /// 날짜 선택
    @objc func tapDateLabel(_ sender: UITapGestureRecognizer) {
        
        guard let tag = sender.view?.tag,
              let viewTag = DateLabelTag.init(rawValue: tag) else { return }
        
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.bottomViewType = viewTag == .startDateLabel ? .startDate : .endDate
        if viewTag == .startDateLabel,
           let startDateText = self.startDateLabel.text {
            bottomVC.preDate = startDateText
        }
        if viewTag == .endDateLabel,
           let endDateText = self.endDateLabel.text {
            bottomVC.preDate = endDateText
        }
        bottomVC.dateDelegate = self
        self.present(bottomVC, animated: true, completion: nil)
    }

    /// 반복주기 클릭 - 클릭시 [String] 에 추가(차후 수정)
    @objc func onTapDayNotiBtn(_ sender: UIButton) {
        
        guard let selectedTag = DetailNotiDayBtnTag.init(rawValue: sender.tag) else { return }
        if selectedTag == .everyday {
            self.selectedNotiDay.removeAll()
            for btn in self.selectedNotiBtnList {
                guard let btnTag = DetailNotiDayBtnTag.init(rawValue: btn.tag) else { return }
                
                btn.isSelected = !sender.isSelected
                btn.backgroundColor = btn.isSelected ? .mainColor : .lightGrayColor
                
                if btn.isSelected {
                    self.selectedNotiDay.append(btnTag)
                } else {
                    self.selectedNotiDay = self.selectedNotiDay.filter { $0 != btnTag }
                }
                
                
            }
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = sender.isSelected ? .mainColor : .lightGrayColor
        
        if sender.isSelected {
            self.selectedNotiDay.append(selectedTag)
        } else {
            
            for btn in self.selectedNotiBtnList {
                guard let btnTag = DetailNotiDayBtnTag.init(rawValue: btn.tag) else { return }
                if btnTag == .everyday {
                    btn.isSelected = false
                    btn.backgroundColor = btn.isSelected ? .mainColor : .lightGrayColor
                    self.selectedNotiDay = self.selectedNotiDay.filter { $0 != btnTag }
                }
            }
            
            self.selectedNotiDay = self.selectedNotiDay.filter { $0 != selectedTag }
        }
        
        self.cycleTimeLabel.isEnabled = self.selectedNotiDay.count > 0
    }
    
    //FIXME: 디테일 업데이트 함수 수정중
    @objc func onTapSubmitBtn() {
       
        guard let startDate = self.startDateLabel.text?.stringToDate(),
              let endDate = self.endDateLabel.text?.stringToDate(),
              startDate <= endDate
        else {
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                            message: RadMessage.AlertView.compareDateError,
                                                            isNeedCancel: false,
                                                            viewController: self)
            return
        }
        
        guard let todoIdx = self.detailInfoModel.todo_id else { return }
        
        // 입력한 값들을 모델에 입력
        self.detailInfoModel.title = self.titleTextField.text?.encodeEmoji()
        
        self.detailInfoModel.fr_date = self.startDateLabel.text
        self.detailInfoModel.ed_date = self.endDateLabel.text
        
        let notiCycle = self.selectedNotiToStringArr().joined(separator: ",")
        
        let isCheck = self.isCheckAuth ? "Y" : "N"
        
        func updateUI() {
            self.setUIValue()
            self.setUI()
            self.appendNotificationSchedule()
        }
        
        func reDetectDetailVM(_frDate: String?) {
            guard let frDate = self.detailInfoModel.fr_date
            else { return }
            _ = TodoDetailViewModel.init(todoIdx, _frDate ?? frDate) { model in
                self.detailInfoModel = model
                if self.isForInviteFriend {
                    self.isForInviteFriend = false
                    self.invitedMemId = nil
                }
                updateUI()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title,
                                                               message: RadMessage.AlertView.successUptDetail,
                                                               isNeedCancel: false,
                                                               viewController: self)
                    
                    guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
                    rootVC.hideLoadingView()
                }
            } errHandler: { Dprint("occur Error \($0)") }
        }
        
        if self.isForInviteFriend {
            guard let invitedMemId = self.invitedMemId
            else { Dprint("was fail something"); return }
            
            _ = TodoCreateChallengeViewModel.init(todoIdx, invitedMemId) {
                self.detailInfoModel.chaluser_yn = "Y"
                self.detailInfoModel.challange_status = TodoChallStatus.doing.rawValue
                _ = TodoDetailUpdateViewModel.init(self.detailInfoModel,
                                                   notiCycle: notiCycle.isEmpty ? nil : notiCycle,
                                                   notiTime: notiCycle.isEmpty ? nil : self.cycleTimeLabel.text) {
                    reDetectDetailVM(_frDate: nil)
                    
                } errHandler: { Dprint("occur Error \($0)") }
            } errHandler: { Dprint("error \($0)") }
            return
        }
        
        _ = TodoDetailUpdateViewModel.init(self.detailInfoModel,
                                           notiCycle: notiCycle.isEmpty ? nil : notiCycle,
                                           notiTime: notiCycle.isEmpty ? nil : self.cycleTimeLabel.text) {
            
            // 본인 인증
            // 인증 수단이 체크가 되었는지 확인
            if self.isCheckAuth != false || self.selectedImage.count > 0 || self.audioRecorder != nil {
                
                func createCertificateVM() {
                    _ = TodoCreateCertificateViewModel.init(todoIdx, UserModel.memberId ?? "", isCheck, self.selectedImage, self.audioRecorder, { handler in
                        
                        if handler {
                            // 업로드 성공
                            reDetectDetailVM(_frDate: self.selectedDay)
                        } else {
                            // 업로드 실패
                            RadAlertViewController.alertControllerShow(WithTitle: RadMessage.basicTitle,
                                                                       message: RadMessage.AlertView.authUploadFail,
                                                                       isNeedCancel: false,
                                                                       viewController: self)
                        }
                    })
                }
                
                self.aleadyRegisterAuth ? reDetectDetailVM(_frDate: nil) : createCertificateVM()
                
            } else {
                reDetectDetailVM(_frDate: nil)
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
        guard self.cycleTimeLabel.isEnabled else { return }
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.bottomViewType = .cycleTime
        // 선택한 시간을 넘겨줘야함
        bottomVC.selectedTime = self.detailInfoModel.noti_time == nil ? Calendar.current.makesTimeToString() : self.noti_time
        bottomVC.timeDelegate = self
        
        self.present(bottomVC, animated: true, completion: nil)
        
    }
    
    /// 오디오 버튼 클릭
    @objc func audioAuth(_ sender:UIButton) {
        
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.bottomViewType = .audioRecord
        //bottomVC.defaultHeight = self.view.frame.height / 2.8
        bottomVC.audioDelegate = self
        self.present(bottomVC, animated: true, completion: nil)
    }
    
    /// 이미지 버튼 클릭
    @objc func photoAlbumAuth(_ sender: UIButton) {
        guard self.selectedImage.count < 3 else {
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                            message: RadMessage.AlertView.inputImgMaxCount,
                                                            isNeedCancel: false,
                                                            viewController: self)
            return
        }
        
        let vc = FMPhotoPickerViewController(config: config())
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    /// 녹음 파일 삭제
    @objc func audioDeleteButtonAction(_ sender: UIButton) {
        
        RadAlertViewController.alertControllerShow(WithTitle: "알림", message: "정말로 삭제하시겠습니까?", isNeedCancel: true, viewController: self) { check in
            
            if check, let deleteUrl = self.audioRecorder?.url {
                
                do {
                    try FileManager.default.removeItem(at: deleteUrl)
                    
                    self.audioPlayArea.isHidden = true
                    self.regiAuthUpdate(isShow: false)
                    self.isRegisterAuth = false
                    
                } catch _ {
                    print("audioFile remove failed")
                }
                
            } else {
                print("audioRecorder url nil")
            }
            
        }
        
        if self.audioPlayer != nil {
            self.progressTimer.invalidate()
        }
        
    }
    
    /// 녹음파일 재생 및 정지
    @objc func audioPlayStopButtonAction(_ sender: UIButton) {
        
        guard let recorder = self.audioRecorder else { return }
        
        self.audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
        if let player = self.audioPlayer {
            player.delegate = self
            
            if sender.imageView?.image == UIImage(named: "btnPlayCircle") {
                player.play()
                sender.setImage(UIImage(named: "btnPauseCircle"), for: .normal)
                progressTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                     target: self,
                                                     selector: timeRecordSelector,
                                                     userInfo: nil,
                                                     repeats: true)
            } else {
                player.pause()
                sender.setImage(UIImage(named: "btnPlayCircle"), for: .normal)
            }
        } else {
            print("player nil error")
        }
        
    }
    
    /// 앱종료시 녹음 파일 삭제
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
    
    /// 인증 버튼 공통 함수
    @objc func onTapAuthBtnCommon(_ sender: UIButton) {
        guard let tappedBtnType = DetailAuthBtnTag.init(rawValue: sender.tag) else { return }
        if self.isRegisterAuth {
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                            message: RadMessage.AlertView.alreadyRegistAuth,
                                                            isNeedCancel: false,
                                                            viewController: self)
            return
        } else if self.isForInviteFriend {
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                            message: RadMessage.AlertView.cntAuthBeforInvite,
                                                            isNeedCancel: false,
                                                            viewController: self)
            return
        }
        switch tappedBtnType {
        case .image:
            self.photoAlbumAuth(sender)
        case .audio:
            self.audioAuth(sender)
        case .check:
            self.authCheckButtonAction(sender)
        }
    }
    
    /// 단순 체크 인증
    @objc func authCheckButtonAction(_ sender: UIButton) {
        self.regiAuthUpdate(isShow: true)
        
        if !isRegisterAuth {
            checkAnimation.isHidden = false
            checkAnimation.play()
            self.isRegisterAuth = true
            self.isCheckAuth = true
        } else {
            RadAlertViewController.alertControllerShow(WithTitle: RadMessage.basicTitle, message: "인증을 취소하시겠습니까?", isNeedCancel: true, viewController: self) { check in
                
                if check {
                    self.isRegisterAuth = false
                    self.regiAuthUpdate(isShow: false)
                    self.checkAnimation.isHidden = true
                    self.checkAnimation.play(toFrame: 0)
                }
                
            }
        }
        
        
        
    }
    
    /// 친구 초대위해 초대 링크 전송하는 함수
    @objc func inviteFriendWithSendSMS() {
        
        self.showLoadingView()
        
        if RadHelper.isLogin() == false {
            self.hideLoadingView()
            RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title,
                                                       message: RadMessage.AlertView.cntInviteFriend,
                                                       isNeedCancel: false,
                                                       viewController: self)
            return
        }
        
        if MFMessageComposeViewController.canSendText(),
           let createUser = detailInfoModel?.created_user,
           let todoIdx = detailInfoModel?.todo_id {
            // https://challinvite?custid=[초대한유저ID]&todoidx=[초대한할일Idx] 링크 형태 참고
            let deeplinkStr = "https://challinvite?custid=\(createUser)&todoidx=\(todoIdx)"
            RadHelper.createDynamicLink(with: deeplinkStr.encodeUrl() ?? deeplinkStr) { url in
                Dprint("link \(String(describing: url))")
                guard let deepLinkUrl = url else { return }
                let messageComposeViewController = MFMessageComposeViewController()
                messageComposeViewController.body = "[단,하루 초대장]\n단,하루 앱에 초대 받았어요! 친구와 함께 목표를 달성해 보세요!\n 👉🏼 \(deepLinkUrl)"
                messageComposeViewController.messageComposeDelegate = self
                self.present(messageComposeViewController, animated: true, completion: nil)
            }
            
        } else {
            self.hideLoadingView()
            RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title,
                                                       message: RadMessage.AlertView.disableInvite,
                                                       isNeedCancel: false,
                                                       viewController: self)
        }
    }
    
    /// 푸시 토큰 허용 및 삭제
    //FIXME: 토큰 삭제 API 추가시 수정 필요
    @objc func changeNotificationState(_ button: UIButton) {
        //let msg = button.isSelected ? RadMessage.AlertView.notiStateChangeOff : RadMessage.AlertView.notiStateChangeOn
        
        let isSelected = button.imageView?.image == UIImage(named: "unmute")
        
        let msg = isSelected ? RadMessage.AlertView.notiStateChangeOff : RadMessage.AlertView.notiStateChangeOn
        
        // 푸시 토큰 등록 및 삭제
        RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                        message: msg,
                                                        isNeedCancel: true,
                                                        viewController: self) {
            
            if $0 {
                
                guard let fcmToken = Messaging.messaging().fcmToken,
                      let todoIdx = self.detailInfoModel.todo_id
                else { return }
                
                let notiImage = isSelected ? UIImage(named: "mute") : UIImage(named: "unmute")
                button.setImage(notiImage, for: .normal)
                
                ViewModelService.todoSubjectTokenDeleteService(fcmToken, todoIdx)
                UserDefaults.standard.setValue(isSelected ? "N" : "Y", forKey: "\(todoIdx)")
            }
            
        }
    
    }
    
    @objc func sendPushButtonAction(_ sender: UIButton) {
        
        guard let todoIdx = self.detailInfoModel.todo_id,
              let todoTitle = self.detailInfoModel.decodedTitle
        else { return }
        ViewModelService.todoSubjectSendPush(RadMessage.basicTitle, "오늘도 단,하루와 함께 일정을 관리해요. \n'\(todoTitle)' 에서 인증을 해주세요.", todoIdx)
        
    }
    
}



extension TodoListDetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension TodoListDetailViewController: FMPhotoPickerViewControllerDelegate {
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        Dprint("did FinishPickingPhoto with \(photos)")
        self.selectedImage.append(contentsOf: photos)
        self.authImageCollectionView.reloadData()
        self.authImageCollectionView.isHidden = false
        self.regiAuthUpdate(isShow: true)
        self.isRegisterAuth = true
    }
}
