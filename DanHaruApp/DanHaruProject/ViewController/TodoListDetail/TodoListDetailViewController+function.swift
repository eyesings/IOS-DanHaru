//
//  TodoListDetailViewController+function.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/09.
//

import Foundation
import UIKit
import AVFoundation

extension TodoListDetailViewController: AVAudioPlayerDelegate, AudioUIChangeProtocol, CheckDateChangeProtocol, CheckTimeChangeProtocol {
    
    //MARK: - UI 오토레이아웃 지정
    func setUI() {
        self.view.backgroundColor = .backgroundColor
        
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(self.view).offset(10)
            make.height.width.equalTo(35)
        }
        
        
        self.view.addSubview(bottomBtn)
        bottomBtn.addTarget(self, action: #selector(self.onTapSubmitBtn), for: .touchUpInside)
        bottomBtn.snp.makeConstraints { make in
            make.width.centerX.equalTo(self.view)
            make.height.equalTo(60)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        
        self.view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.backBtn.snp.bottom)
            make.centerX.width.equalTo(self.view)
            make.bottom.equalTo(self.bottomBtn.snp.top)
        }
        
        
        self.mainScrollView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.mainScrollView).offset(10)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.7)
            make.height.equalTo(40)
            make.leading.equalTo(self.mainScrollView).offset(20)
        }
        
        
        self.mainScrollView.addSubview(durationTitleLabel)
        durationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.leading.equalTo(self.titleTextField)
        }
        
        
        self.mainScrollView.addSubview(middleLabel)
        middleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.durationTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(35)
            make.centerX.equalTo(self.view)
            make.width.equalTo(screenwidth * 0.15)
        }
        
        self.mainScrollView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.height.equalTo(middleLabel)
            make.width.equalTo(self.view).multipliedBy(0.35)
            make.trailing.equalTo(self.middleLabel.snp.leading)
        }
        
        self.mainScrollView.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.top.width.height.equalTo(startDateLabel)
            make.leading.equalTo(middleLabel.snp.trailing)
        }
        
        self.mainScrollView.addSubview(cycleTitleLabel)
        cycleTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(20)
            make.leading.height.equalTo(durationTitleLabel)
        }
        
        
        self.mainScrollView.addSubview(cycleExplainLabel)
        cycleExplainLabel.snp.makeConstraints { make in
            make.leading.equalTo(cycleTitleLabel)
            make.width.equalTo(self.mainScrollView)
            make.top.equalTo(cycleTitleLabel.snp.bottom)
        }
        
        self.createCircleDateButton()
        
        self.mainScrollView.addSubview(cycleTimeLabel)
        cycleTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mondayNotiBtn.snp.bottom).offset(25)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.4)
            make.height.equalTo(startDateLabel)
            make.centerX.equalTo(self.view)
        }
        
        
        self.mainScrollView.addSubview(authTitleLable)
        authTitleLable.snp.makeConstraints { make in
            make.top.equalTo(cycleTimeLabel.snp.bottom).offset(25)
            make.leading.height.equalTo(durationTitleLabel)
        }
        
        let authPadding = screenwidth * 0.08
        self.mainScrollView.addSubview(authAudioBtn)
        authAudioBtn.snp.makeConstraints { make in
            make.top.equalTo(authTitleLable.snp.bottom).offset(20)
            make.height.width.equalTo(self.view.frame.width * 0.2)
            make.centerX.equalTo(self.view)
        }
        
        self.mainScrollView.addSubview(authImageBtn)
        authImageBtn.snp.makeConstraints { make in
            make.top.width.height.equalTo(self.authAudioBtn)
            make.trailing.equalTo(self.authAudioBtn.snp.leading).offset(-authPadding)
        }
        
        
        self.mainScrollView.addSubview(authCheckBtn)
        authCheckBtn.snp.makeConstraints { make in
            make.top.width.height.equalTo(self.authAudioBtn)
            make.leading.equalTo(self.authAudioBtn.snp.trailing).offset(authPadding)
        }
        
        if !isAudioAuth {
            // 오디오 인증 안함
            self.mainScrollView.addSubview(audioPlayArea)
            audioPlayArea.snp.makeConstraints { make in
                make.top.equalTo(self.authCheckBtn.snp.bottom).offset(25)
                make.width.equalTo(self.view).multipliedBy(0.8)
                make.height.equalTo(0)
                make.centerX.equalTo(self.view)
            }
            audioPlayArea.backgroundColor = .clear
            
            self.audioPlayArea.addSubview(audioPlayTimeText)
            audioPlayTimeText.snp.makeConstraints { make in
                make.width.equalTo(self.view).multipliedBy(0.2)
                make.centerX.centerY.equalTo(audioPlayArea)
                make.height.equalTo(self.audioPlayArea).multipliedBy(0.8)
            }
            audioPlayTimeText.adjustsFontSizeToFitWidth = true
            audioPlayTimeText.textAlignment = .center
            audioPlayTimeText.text = "00:00"
            
            
            self.audioPlayArea.addSubview(audioPlayStopBtn)
            audioPlayStopBtn.snp.makeConstraints { make in
                make.centerY.height.equalTo(self.audioPlayArea)
                make.width.equalTo(screenwidth * 0.07)
                make.trailing.equalTo(self.audioPlayTimeText.snp.leading)
            }
            audioPlayStopBtn.setImage(UIImage(named: "btnPlayCircle"), for: .normal)
            audioPlayStopBtn.imageView?.contentMode = .scaleAspectFit
            audioPlayStopBtn.addTarget(self, action: #selector(audioPlayStopButtonAction(_:)), for: .touchUpInside)
            
            self.audioPlayArea.addSubview(recordDeleteBtn)
            recordDeleteBtn.snp.makeConstraints { make in
                make.centerY.width.height.equalTo(self.audioPlayStopBtn)
                make.leading.equalTo(self.audioPlayTimeText.snp.trailing)
            }
            recordDeleteBtn.setImage(#imageLiteral(resourceName: "btnTrash"), for: .normal)
            recordDeleteBtn.imageView?.contentMode = .scaleAspectFit
            recordDeleteBtn.addTarget(self, action: #selector(audioDeleteButtonAction(_:)), for: .touchUpInside)
            //recordDeleteBtn.layer.borderColor = UIColor.black.cgColor
            //recordDeleteBtn.layer.borderWidth = 1.0
        } else {
            // 오디오로 인증 함, 인증 후에 다시 들어왔을 때 보여지는 UI
        }
        
        
        if !self.isImageAuth {
            // 인증 방법에 따라서 보여지고 가려지고 해야함
            self.mainScrollView.addSubview(authImageView1)
            authImageView1.snp.makeConstraints { make in
                make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                make.width.equalTo(self.view).multipliedBy(0.22)
                make.height.equalTo(0)
                make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
            }
            
            self.mainScrollView.addSubview(imageDeleteBtn1)
            imageDeleteBtn1.snp.makeConstraints { make in
                make.top.equalTo(authImageView1).offset(0)
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.trailing.equalTo(authImageView1).offset(0)
            }
            
            self.mainScrollView.addSubview(authImageView2)
            authImageView2.snp.makeConstraints { make in
                make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                make.width.equalTo(self.view).multipliedBy(0.22)
                make.height.equalTo(0)
                make.left.equalTo(authImageView1.snp.right).offset(self.view.frame.width * 0.02)
            }
            
            self.mainScrollView.addSubview(imageDeleteBtn2)
            imageDeleteBtn2.snp.makeConstraints { make in
                make.top.equalTo(authImageView2).offset(0)
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.trailing.equalTo(authImageView2).offset(0)
            }
            
            
            self.mainScrollView.addSubview(authImageView3)
            authImageView3.snp.makeConstraints { make in
                make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                make.width.equalTo(self.view).multipliedBy(0.22)
                make.height.equalTo(0)
                make.left.equalTo(authImageView2.snp.right).offset(self.view.frame.width * 0.02)
            }
            
            self.mainScrollView.addSubview(imageDeleteBtn3)
            imageDeleteBtn3.snp.makeConstraints { make in
                make.top.equalTo(authImageView2).offset(0)
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.trailing.equalTo(authImageView3).offset(0)
            }
            
        } else {
            // 이미지로 인증
        }
        
        // 단순체크로 인증
        if !isCheckAuth {
            
            self.mainScrollView.addSubview(checkAnimation)
            checkAnimation.snp.makeConstraints { make in
                make.top.equalTo(authImageView1.snp.bottom).offset(10)
                make.width.equalTo(self.view.frame.width).multipliedBy(0.25)
                make.centerX.equalTo(self.view)
                make.height.equalTo(0)
            }
            checkAnimation.animation = .named("check_black")
            checkAnimation.loopMode = .playOnce
            
        }
        
        
        self.mainScrollView.addSubview(togetherFriendTitleLabel)
        togetherFriendTitleLabel.snp.makeConstraints { make in
            
            make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
            make.leading.equalTo(self.authTitleLable)
            make.height.equalTo(self.authTitleLable)
            
        }
        
        
        self.mainScrollView.addSubview(togetherExplainLabel)
        togetherExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.togetherFriendTitleLabel.snp.bottom)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.leading.equalTo(self.togetherFriendTitleLabel)
            make.height.equalTo(15)
        }
        
        let collectionViewHeihgt = 100.0
        self.mainScrollView.addSubview(togetherFriendCollectionView)
        togetherFriendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(togetherExplainLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.view)
            make.width.equalTo(screenwidth * 0.75)
            make.height.equalTo(collectionViewHeihgt)
        }
        
        self.mainScrollView.addSubview(inviteFriendBtn)
        inviteFriendBtn.snp.makeConstraints { make in
            make.width.height.equalTo(collectionViewHeihgt * 0.7)
            make.leading.equalTo(togetherFriendCollectionView.snp.trailing)
            make.centerY.equalTo(togetherFriendCollectionView)
        }
        
        self.mainScrollView.addSubview(todayAuthTitleLabel)
        todayAuthTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(togetherFriendCollectionView.snp.bottom).offset(20)
            make.height.leading.equalTo(self.togetherFriendTitleLabel)
        }
        
        self.mainScrollView.addSubview(notificationStateBtn)
        notificationStateBtn.snp.makeConstraints { make in
            make.top.bottom.equalTo(todayAuthTitleLabel)
            make.leading.equalTo(todayAuthTitleLabel.snp.trailing).offset(10)
            make.width.equalTo(notificationStateBtn.snp.height)
        }
        
        // 친구 명 수대로 imageview 가 생겨야하고.. 버튼도 생겨야하고... 인증 현황에 따라서 버튼을 체크 모양으로 변경해야함...
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        self.todayAuthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.mainScrollView.addSubview(todayAuthCollectionView)
        todayAuthCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.todayAuthTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(180)
        }
        
        
        self.mainScrollView.addSubview(weeklyTitleLabel)
        weeklyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.todayAuthCollectionView.snp.bottom).offset(20)
            make.leading.height.equalTo(self.togetherFriendTitleLabel)
        }
        
        self.mainScrollView.addSubview(weeklyTableView)
        weeklyTableView.snp.makeConstraints { make in
            make.top.equalTo(weeklyTitleLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.9)
            make.height.equalTo(self.tableViewHeight)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.mainScrollView).offset(-20)
        }
        
        self.setLayout()
        
    }
    
    // MARK: - UI 레이아웃 지정
    func setLayout() {
        // 상단 뒤로가기 버튼
        backBtn.setImage(#imageLiteral(resourceName: "btnArrowLeft"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(_:)), for: .touchUpInside)
        
        // 하단 확인 버튼
        bottomBtn.setTitle(self.isForInviteFriend ? "함께하기" : "확인", for: .normal)
        bottomBtn.backgroundColor = .subHeavyColor
        bottomBtn.setTitleColor(.white, for: .normal)
        
        // 메인 스크롤뷰
        mainScrollView.backgroundColor = .backgroundColor
        mainScrollView.showsVerticalScrollIndicator = false
        
        // 제목 수정
        titleTextField.text = titleText;
        titleTextField.adjustsFontSizeToFitWidth = true
        titleTextField.textAlignment = .left
        titleTextField.font = UIFont.boldSystemFont(ofSize: 25)
        
        // FIXME: 어디에 둬야할지 몰라서 여기에 둡니다. 원하는 곳으로 이동시켜주세요.
        func customLabelConfig(_ textLabel: UILabel) {
            textLabel.textColor = .customBlackColor
            textLabel.textAlignment = .center
            textLabel.font = .systemFont(ofSize: 15.0)
        }
        
        // FIXME: 어디에 둬야할지 몰라서 여기에 둡니다. 원하는 곳으로 이동시켜주세요.
        func customTitleLabelConfig(_ textLabel: UILabel) {
            textLabel.textAlignment = .left
            textLabel.font = .boldSystemFont(ofSize: 20)
            textLabel.sizeToFit()
        }
        
        // FIXME: 어디에 둬야할지 몰라서 여기에 둡니다. 원하는 곳으로 이동시켜주세요.
        func customButtonConfig(_ button: UIButton) {
            let edgeInset = self.view.frame.width * 0.05
            button.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
            button.imageView?.contentMode = .scaleAspectFit
            button.createShadow(CGSize(width: 2, height: 2), 5)
            button.backgroundColor = .backgroundColor
            button.layer.cornerRadius = 20
        }
        
        func commonInfoLabelConfig(_ textLabel: UILabel) {
            textLabel.textAlignment = .left
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.font = UIFont.italicSystemFont(ofSize: 13)
            textLabel.textColor = .heavyGrayColor
        }
        
        // 기간선택
        durationTitleLabel.text = "기간 선택"
        customTitleLabelConfig(durationTitleLabel)
        
        // 시작 날짜 라벨
        startDateLabel.text = "\(startDate)"
        customLabelConfig(startDateLabel)
        startDateLabel.tag = DateLabelTag.startDateLabel.rawValue
        let startTap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        startDateLabel.addGestureRecognizer(startTap)
        
        // 날짜 사이 라벨
        middleLabel.text = "~"
        middleLabel.adjustsFontSizeToFitWidth = true
        middleLabel.textColor = .customBlackColor
        middleLabel.textAlignment = .center

        
        // 종료 날짜 라벨
        endDateLabel.text = "\(endDate)"
        customLabelConfig(endDateLabel)
        endDateLabel.tag = DateLabelTag.endDateLabel.rawValue
        let endTap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        endDateLabel.addGestureRecognizer(endTap)
        
        // 주기 선택 라벨
        cycleTitleLabel.text = "주기 선택"
        customTitleLabelConfig(cycleTitleLabel)
        
        // 주기 선택 라벨 설명
        cycleExplainLabel.text = "* 선택 한 주기마다 알림이 전송 됩니다."
        commonInfoLabelConfig(cycleExplainLabel)
        
        // 반복 주기 시간 선택
        cycleTimeLabel.text = self.noti_time
        customLabelConfig(cycleTimeLabel)
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(circleTimeLabelAction(_:)))
        cycleTimeLabel.addGestureRecognizer(timeTap)
        
        // 인증 라벨
        authTitleLable.text = "인증 등록"
        customTitleLabelConfig(authTitleLable)
        
        // 인증 수단 - 이미지
        authImageBtn.setImage(UIImage(named: "btnPhotoAlbum"), for: .normal)
        authImageBtn.addTarget(self, action: #selector(photoAlbumAuth(_:)), for: .touchUpInside)
        customButtonConfig(authImageBtn)
        
        // 인증 수단 - 오디오
        authAudioBtn.setImage(UIImage(named: "btnMic"), for: .normal)
        authAudioBtn.addTarget(self, action: #selector(audioAuth(_:)), for: .touchUpInside)
        customButtonConfig(authAudioBtn)
        
        // 인증 수단 - 체크
        authCheckBtn.setImage(UIImage(named:"btnCheck"), for: .normal)
        authCheckBtn.addTarget(self, action: #selector(authCheckButtonAction(_:)), for: .touchUpInside)
        customButtonConfig(authCheckBtn)
        
        // 이미지 인증 이미지뷰1
        authImageView1.backgroundColor = .lightGrayColor
        
        // 이미지 인증 삭제 버튼1
        imageDeleteBtn1.setImage(#imageLiteral(resourceName: "btnCloseSel"), for: .normal)
        imageDeleteBtn1.backgroundColor = .white
        imageDeleteBtn1.layer.borderWidth = 1.0
        imageDeleteBtn1.layer.borderColor = UIColor.lightGray.cgColor
        imageDeleteBtn1.tag = ImageDeleteBtnTag.deleteImageView1.rawValue
        imageDeleteBtn1.layer.cornerRadius = self.view.frame.width * 0.22 * 0.3 / 2
        imageDeleteBtn1.addTarget(self, action: #selector(deleteAuthImage(_:)), for: UIControl.Event.touchUpInside)
        
        // 이미지 인증 이미지뷰2
        authImageView2.backgroundColor = .lightGrayColor
        
        // 이미지 인증 삭제 버튼2
        imageDeleteBtn2.setImage(#imageLiteral(resourceName: "btnCloseSel"), for: .normal)
        imageDeleteBtn2.backgroundColor = .white
        imageDeleteBtn2.layer.borderWidth = 1.0
        imageDeleteBtn2.layer.borderColor = UIColor.lightGray.cgColor
        imageDeleteBtn2.tag = ImageDeleteBtnTag.deleteImageView2.rawValue
        imageDeleteBtn2.layer.cornerRadius = self.view.frame.width * 0.22 * 0.3 / 2
        imageDeleteBtn2.addTarget(self, action: #selector(deleteAuthImage(_:)), for: .touchUpInside)
        
        // 이미지 인증 이미지뷰3
        authImageView3.backgroundColor = .lightGrayColor
        
        // 이미지 인증 삭제 버튼3
        imageDeleteBtn3.setImage(#imageLiteral(resourceName: "btnCloseSel"), for: .normal)
        imageDeleteBtn3.backgroundColor = .white
        imageDeleteBtn3.layer.borderWidth = 1.0
        imageDeleteBtn3.layer.borderColor = UIColor.lightGray.cgColor
        imageDeleteBtn3.tag = ImageDeleteBtnTag.deleteImageView3.rawValue
        imageDeleteBtn3.layer.cornerRadius = self.view.frame.width * 0.22 * 0.3 / 2
        imageDeleteBtn3.addTarget(self, action: #selector(deleteAuthImage(_:)), for: .touchUpInside)
        
        // 함께 도전 라벨
        togetherFriendTitleLabel.text = "함께 도전 중인 친구"
        customTitleLabelConfig(togetherFriendTitleLabel)
        
        // 함께 도전 설명 라벨
        togetherExplainLabel.text = "* 친구를 초대 하고 함께 도전을 진행해 보세요!"
        commonInfoLabelConfig(togetherExplainLabel)
        
        togetherFriendCollectionView.delegate = self
        togetherFriendCollectionView.dataSource = self
        togetherFriendCollectionView.showsHorizontalScrollIndicator = false
        togetherFriendCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        togetherFriendCollectionView.bounces = false
        
        inviteFriendBtn.backgroundColor = .subLightColor
        inviteFriendBtn.setImage(UIImage(named: "btnAdd"), for: .normal)
        inviteFriendBtn.imageView?.contentMode = .scaleAspectFit
        inviteFriendBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        inviteFriendBtn.addTarget(self, action: #selector(inviteFriendWithSendSMS), for: .touchUpInside)
        
        // 오늘 인증 라벨
        todayAuthTitleLabel.text = "오늘 인증 현황"
        customTitleLabelConfig(todayAuthTitleLabel)
        
        notificationStateBtn.setImage(UIImage(named: "unmute"), for: .normal)
        notificationStateBtn.isSelected = true
        notificationStateBtn.addTarget(self, action: #selector(changeNotificationState), for: .touchUpInside)
        
        // 오늘 인증 콜렉션 뷰
        todayAuthCollectionView.delegate = self
        todayAuthCollectionView.dataSource = self
        todayAuthCollectionView.backgroundColor = .clear
        todayAuthCollectionView.register(UINib(nibName: "TodoListDetailCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: TodoListDetailCollectionViewCell.reusableIdentifier)
        todayAuthCollectionView.showsHorizontalScrollIndicator = false
        todayAuthCollectionView.tag = DetailCollectionViewTag.currAuth.rawValue
        todayAuthCollectionView.bounces = false
        todayAuthCollectionView.decelerationRate = .normal
        
        // 위클리 리포트 라벨
        weeklyTitleLabel.text = "위클리 리포트"
        customTitleLabelConfig(weeklyTitleLabel)
        
        // 위클리 리포트 테이블 뷰
        /*
        weeklyTableView.register(UINib(nibName: "TodoListDetailTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: TodoListDetailTableViewCell.reusableIdentifier)
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        weeklyTableView.showsVerticalScrollIndicator = false
        weeklyTableView.isPagingEnabled = true
        weeklyTableView.backgroundColor = .backgroundColor
        weeklyTableView.separatorStyle = .none
        */
    }
    
    //MARK: - 이미지 앨범 불러오기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        if newImage != nil {
            self.isImageAuth = true
            if authImageView1.image == nil {
                // 이미지 뷰가 보여야함
                self.authImageView1.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
                }
                
                self.imageDeleteBtn1.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView1).offset(-5)
                    make.width.equalTo(authImageView1).multipliedBy(0.3)
                    make.height.equalTo(authImageView1).multipliedBy(0.3)
                    make.trailing.equalTo(authImageView1).offset(5)
                }
                
                
                self.authImageView1.image = newImage
                
            } else if authImageView2.image == nil {
                
                authImageView2.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(authImageView1.snp.right).offset(self.view.frame.width * 0.02)
                }
                
                self.imageDeleteBtn2.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView2).offset(-5)
                    make.width.equalTo(authImageView2).multipliedBy(0.3)
                    make.height.equalTo(authImageView2).multipliedBy(0.3)
                    make.trailing.equalTo(authImageView2).offset(5)
                }
                
                self.authImageView2.image = newImage
                
            } else if authImageView3.image == nil {
                
                authImageView3.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(authImageView2.snp.right).offset(self.view.frame.width * 0.02)
                }
                
                self.imageDeleteBtn3.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView3).offset(-5)
                    make.width.equalTo(authImageView3).multipliedBy(0.3)
                    make.height.equalTo(authImageView3).multipliedBy(0.3)
                    make.trailing.equalTo(authImageView3).offset(5)
                }
                
                self.authImageView3.image = newImage
                
            } else {
                
                RadAlertViewController.alertControllerShow(WithTitle: "알림", message: "인증 사진은 최대 3개까지 가능합니다.", isNeedCancel: false, viewController: self)
                
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            self.audioPlayStopBtn.setImage(UIImage(named: "btnPlayCircle"), for: .normal)
            if let recorder = self.audioRecorder {
                let audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                
                if let player = audioPlayer {
                    self.audioPlayTimeText.text = "\(RadHelper.convertNSTimeInterval12String(player.duration))"
                }
                
            }
        }
        self.progressTimer.invalidate()
    }
    
    /// 오디오 등록 후 UI 변경
    func audioUIChange(_ audio: AVAudioRecorder?) {
        
        self.isAudioAuth = true
        
        self.audioRecorder = audio
        
        audioPlayArea.snp.remakeConstraints { make in
            make.top.equalTo(self.authCheckBtn.snp.bottom).offset(25)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
        }
        if let recorder = self.audioRecorder {
            let audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
            
            if let player = audioPlayer {
                self.audioPlayTimeText.text = "\(RadHelper.convertNSTimeInterval12String(player.duration))"
            }
            
        }
        
    }
    
    /// 날짜 선택 후 날짜 변경
    func dateChange(_ divisionCode: String, _ text: String) {
        
        if divisionCode == BottomViewCheck.startDate.rawValue {
            self.startDateLabel.text = text
        } else if divisionCode == BottomViewCheck.endDate.rawValue {
            self.endDateLabel.text = text
        }
        
    }
    
    /// 시간 선택 후 시간 변경
    func timeChange(_ text: String) {
        
        self.cycleTimeLabel.text = text
        
    }
    
    // 반복주기 요일 버튼 생성 함수
    func createCircleDateButton() {
        
        mondayNotiBtn = createNotiCircleBtn(type: .monday, to: cycleTitleLabel, isFirst: true)
        let tuesdayNotiBtn = createNotiCircleBtn(type: .tuesday, to: mondayNotiBtn)
        let wednesdayNotiBtn = createNotiCircleBtn(type: .wednesday, to: tuesdayNotiBtn)
        let thursdayNotiBtn = createNotiCircleBtn(type: .thursday, to: wednesdayNotiBtn)
        let fridayNotiBtn = createNotiCircleBtn(type: .friday, to: thursdayNotiBtn)
        let saturdayNotiBtn = createNotiCircleBtn(type: .saturday, to: fridayNotiBtn)
        let sundayNotiBtn = createNotiCircleBtn(type: .sunday, to: saturdayNotiBtn)
        let everyNotiBtn = createNotiCircleBtn(type: .everyday, to: sundayNotiBtn)
        
        self.selectedNotiBtnList.append(mondayNotiBtn)
        self.selectedNotiBtnList.append(tuesdayNotiBtn)
        self.selectedNotiBtnList.append(wednesdayNotiBtn)
        self.selectedNotiBtnList.append(thursdayNotiBtn)
        self.selectedNotiBtnList.append(fridayNotiBtn)
        self.selectedNotiBtnList.append(saturdayNotiBtn)
        self.selectedNotiBtnList.append(sundayNotiBtn)
        self.selectedNotiBtnList.append(everyNotiBtn)
    }
    
    func createNotiCircleBtn(type: DetailNotiDayBtnTag, to parent: UIView, isFirst: Bool = false) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.setTitle(type.name(), for: .normal)
        btn.setTitleColor(.heavyGrayColor, for: .normal)
        btn.setTitleColor(.backgroundColor, for: .selected)
        btn.titleLabel?.font = .systemFont(ofSize: 14.0)
        btn.backgroundColor = RadHelper.colorFromHex(hex: "dddddd")
        btn.layer.cornerRadius = self.view.frame.width * 0.09 / 2
        
        btn.layer.masksToBounds = true
        btn.tag = type.rawValue
        btn.addTarget(self, action: #selector(onTapDayNotiBtn(_:)), for: .touchUpInside)
        
        setLayoutNotiCircleBtn(with: btn, to: parent, isFirst: isFirst)
        
        return btn
    }
    
    func setLayoutNotiCircleBtn(with selfBtn: UIButton, to parent: UIView, isFirst: Bool = false) {
        self.mainScrollView.addSubview(selfBtn)
        selfBtn.snp.makeConstraints { make in
            if isFirst {
                make.top.equalTo(cycleExplainLabel.snp.bottom).offset(10)
                make.leading.equalTo(self.durationTitleLabel).offset(10)
            }
            else {
                make.top.equalTo(parent)
                make.leading.equalTo(parent.snp.trailing).offset(self.view.frame.width * 0.02)
            }
            make.width.equalTo(self.view.frame.width * 0.09)
            make.height.equalTo(selfBtn.snp.width)
        }
    }
    
}
