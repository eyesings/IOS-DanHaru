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
            make.height.equalTo(self.view).multipliedBy(0.05)
            make.width.equalTo(self.view).multipliedBy(0.08)
        }
        
        
        self.view.addSubview(menuBtn)
        menuBtn.snp.makeConstraints { make in
            make.top.width.height.equalTo(self.backBtn)
            make.trailing.equalTo(self.view).offset(-20)
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
        
        
        self.mainScrollView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleTextField.snp.bottom).offset(10)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.5)
            make.height.equalTo(30)
            make.leading.equalTo(self.titleTextField)
        }
        
        
        self.mainScrollView.addSubview(startDateView)
        startDateView.snp.makeConstraints { make in
            make.top.equalTo(self.durationLabel.snp.bottom).offset(10)
            make.width.equalTo(self.view).multipliedBy(0.35)
            make.height.equalTo(40)
            make.leading.equalTo(self.durationLabel)
        }
        
        
        
        self.startDateView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.width.height.bottom.leading.equalTo(self.startDateView)
        }
        
        
        self.mainScrollView.addSubview(middleLabel)
        middleLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel)
            make.centerX.equalTo(self.view)
            make.height.equalTo(startDateLabel)
            make.leading.equalTo(startDateLabel.snp.trailing).offset(self.mainScrollView.frame.width * 0.1)
        }
        
        
        self.mainScrollView.addSubview(endDateView)
        endDateView.snp.makeConstraints { make in
            make.top.width.height.equalTo(startDateView)
            make.leading.equalTo(middleLabel.snp.trailing).offset(self.mainScrollView.frame.width * 0.1)
        }
        
        
        self.endDateView.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.top.bottom.width.height.equalTo(endDateView)
        }
        
        self.mainScrollView.addSubview(cycleLabel)
        cycleLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateView.snp.bottom).offset(20)
            make.leading.equalTo(durationLabel)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.2)
            make.height.equalTo(durationLabel)
        }
        
        
        self.mainScrollView.addSubview(cycleExplainLabel)
        cycleExplainLabel.snp.makeConstraints { make in
            make.top.height.equalTo(cycleLabel)
            make.leading.equalTo(cycleLabel.snp.trailing).offset(5)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.6)
        }
        
        self.createCircleDateButton()
        
        self.mainScrollView.addSubview(cycleTimeLabel)
        cycleTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mondayNotiBtn.snp.bottom).offset(25)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.4)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
        }
        
        
        self.mainScrollView.addSubview(authLable)
        authLable.snp.makeConstraints { make in
            make.top.equalTo(cycleTimeLabel.snp.bottom).offset(25)
            make.leading.height.width.equalTo(durationLabel)
        }
        
        let authPadding = screenwidth * 0.1
        
        self.mainScrollView.addSubview(authImageBtn)
        authImageBtn.snp.makeConstraints { make in
            make.top.equalTo(authLable.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view.frame.width * 0.2)
            make.left.equalTo(self.view).offset(authPadding)
        }
        
        self.mainScrollView.addSubview(authAudioBtn)
        authAudioBtn.snp.makeConstraints { make in
            make.top.width.height.equalTo(self.authImageBtn)
            make.leading.equalTo(self.authImageBtn.snp.trailing).offset(authPadding)
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
                make.width.equalTo(self.view).multipliedBy(0.1)
                make.trailing.equalTo(self.audioPlayTimeText.snp.leading)
            }
            audioPlayStopBtn.setImage(UIImage(named: "btnPlayCircle"), for: .normal)
            audioPlayStopBtn.imageView?.contentMode = .scaleAspectFit
            audioPlayStopBtn.addTarget(self, action: #selector(audioPlayStopButtonAction(_:)), for: .touchUpInside)
            
            self.audioPlayArea.addSubview(recordDeleteBtn)
            recordDeleteBtn.snp.makeConstraints { make in
                make.centerY.width.equalTo(self.audioPlayStopBtn)
                make.height.equalTo(audioPlayArea)
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
        
        
        self.mainScrollView.addSubview(togetherFriendLabel)
        togetherFriendLabel.snp.makeConstraints { make in
            
            make.top.equalTo(self.checkAnimation.snp.bottom).offset(25)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.leading.equalTo(self.authLable)
            make.height.equalTo(self.authLable)
            
        }
        
        
        self.mainScrollView.addSubview(togetherExplainLabel)
        togetherExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.togetherFriendLabel.snp.bottom)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.leading.equalTo(self.togetherFriendLabel)
            make.height.equalTo(15)
        }
        
        /*
        self.mainScrollView.addSubview(friendImageView1)
        friendImageView1.snp.makeConstraints { make in
            make.top.equalTo(self.togetherExplainLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view.frame.width * 0.2)
            make.left.equalTo(self.view).offset(self.view.frame.width * 0.2)
        }
        
        
        self.mainScrollView.addSubview(friendAddBtn1)
        friendAddBtn1.snp.makeConstraints { make in
            make.top.equalTo(self.friendImageView1.snp.bottom).offset(15)
            make.width.equalTo(self.friendImageView1)
            make.height.equalTo(self.friendImageView1)
            make.leading.equalTo(self.friendImageView1)
        }
        
        
        self.mainScrollView.addSubview(friendImageView2)
        friendImageView2.snp.makeConstraints { make in
            make.top.equalTo(friendImageView1)
            make.width.equalTo(friendImageView1)
            make.height.equalTo(friendImageView1)
            make.left.equalTo(friendImageView1.snp.right).offset(self.view.frame.width * 0.2)
        }
        
        
        self.mainScrollView.addSubview(friendAddBtn2)
        friendAddBtn2.snp.makeConstraints { make in
            make.top.equalTo(friendImageView2.snp.bottom).offset(15)
            make.width.equalTo(friendImageView2)
            make.height.equalTo(friendImageView2)
            make.leading.equalTo(friendImageView2)
        }
        */
        
        self.mainScrollView.addSubview(friendImageView1)
        friendImageView1.snp.makeConstraints { make in
            make.top.equalTo(self.togetherExplainLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view.frame.width * 0.2)
            //make.left.equalTo(self.view).offset(self.view.frame.width * 0.2)
            make.centerX.equalTo(self.view)
        }
        
        
        self.mainScrollView.addSubview(friendAddBtn1)
        friendAddBtn1.snp.makeConstraints { make in
            make.top.equalTo(self.friendImageView1.snp.bottom).offset(15)
            make.width.equalTo(self.friendImageView1)
            make.height.equalTo(self.friendImageView1)
            make.leading.equalTo(self.friendImageView1)
        }
        
        self.mainScrollView.addSubview(todayAuthLabel)
        todayAuthLabel.snp.makeConstraints { make in
            make.top.equalTo(friendAddBtn1.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.height.equalTo(self.togetherFriendLabel)
            make.leading.equalTo(self.togetherFriendLabel)
        }
        
        
        // 친구 명 수대로 imageview 가 생겨야하고.. 버튼도 생겨야하고... 인증 현황에 따라서 버튼을 체크 모양으로 변경해야함...
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (self.view.bounds.size.width * 0.9 * 0.32), height: 170.0)
        self.todayAuthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.mainScrollView.addSubview(todayAuthCollectionView)
        todayAuthCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.todayAuthLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.9)
            make.height.equalTo(180)
            make.centerX.equalTo(self.view)
        }
        
        self.mainScrollView.addSubview(weeklyLabel)
        weeklyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.todayAuthCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(self.togetherFriendLabel)
            make.height.equalTo(self.togetherFriendLabel)
            make.width.equalTo(self.togetherFriendLabel)
        }
        
        self.mainScrollView.addSubview(weeklyTableView)
        weeklyTableView.snp.makeConstraints { make in
            make.top.equalTo(weeklyLabel.snp.bottom).offset(20)
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
        
        // 데일리 인증 화면 이동
        menuBtn.setImage(#imageLiteral(resourceName: "btnEdit"), for: .normal)
        menuBtn.imageView?.contentMode = .scaleToFill
        
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
        
        // 기간선택
        durationLabel.text = "기간 선택"
        durationLabel.adjustsFontSizeToFitWidth = true
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // 시작 날짜 라벨 백뷰
        startDateView.backgroundColor = .backgroundColor
        startDateView.alpha = 0.5
        
        // 시작 날짜 라벨
        startDateLabel.text = "\(startDate)"
        startDateLabel.textColor = .black
        startDateLabel.textAlignment = .center
        startDateLabel.adjustsFontSizeToFitWidth = true
        startDateLabel.isUserInteractionEnabled = true
        startDateLabel.tag = DateLabelTag.startDateLabel.rawValue
        let startTap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        startDateLabel.addGestureRecognizer(startTap)
        
        // 날짜 사이 라벨
        middleLabel.text = "~"
        middleLabel.adjustsFontSizeToFitWidth = true
        middleLabel.textColor = .black
        middleLabel.textAlignment = .center
        
        // 종료 날짜 라벨 백뷰
        endDateView.backgroundColor = .backgroundColor
        endDateView.alpha = 0.5
        
        // 종료 날짜 라벨
        endDateLabel.text = "\(endDate)"
        endDateLabel.textColor = .black
        endDateLabel.textAlignment = .center
        endDateLabel.isUserInteractionEnabled = true
        endDateLabel.adjustsFontSizeToFitWidth = true
        endDateLabel.tag = DateLabelTag.endDateLabel.rawValue
        let endTap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        endDateLabel.addGestureRecognizer(endTap)
        
        // 주기 선택 라벨
        cycleLabel.text = "주기 선택"
        cycleLabel.textAlignment = .left
        cycleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cycleLabel.adjustsFontSizeToFitWidth = true
        cycleLabel.textColor = .black
        
        // 주기 선택 라벨 설명
        cycleExplainLabel.text = "* 선택 한 주기마다 알림이 전송 됩니다."
        cycleExplainLabel.textAlignment = .left
        cycleExplainLabel.adjustsFontSizeToFitWidth = true
        cycleExplainLabel.font = UIFont.italicSystemFont(ofSize: 15)
        cycleExplainLabel.textColor = UIColor.lightGrayColor
        
        // 반복 주기 시간 선택
        cycleTimeLabel.text = self.noti_time
        cycleTimeLabel.textAlignment = .center
        cycleTimeLabel.textColor = .black
        cycleTimeLabel.adjustsFontSizeToFitWidth = true
        cycleTimeLabel.font = UIFont.italicSystemFont(ofSize: 20)
        cycleTimeLabel.isUserInteractionEnabled = true
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(circleTimeLabelAction(_:)))
        cycleTimeLabel.addGestureRecognizer(timeTap)
        
        // 인증 라벨
        authLable.text = "인증 등록"
        authLable.textAlignment = .left
        authLable.font = UIFont.boldSystemFont(ofSize: 20)
        authLable.textColor = UIColor.black
        authLable.adjustsFontSizeToFitWidth = true
        
        let edgeInset = self.view.frame.width * 0.05
        // 인증 수단 - 이미지
        authImageBtn.setImage(UIImage(named: "btnPhotoAlbum"), for: .normal)
        authImageBtn.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        authImageBtn.imageView?.contentMode = .scaleAspectFit
        authImageBtn.addTarget(self, action: #selector(photoAlbumAuth(_:)), for: .touchUpInside)
        authImageBtn.createShadow(CGSize(width: 2, height: 2), 5)
        authImageBtn.backgroundColor = .backgroundColor
        authImageBtn.layer.cornerRadius = 20
        
        // 인증 수단 - 오디오
        authAudioBtn.setImage(UIImage(named: "btnMic"), for: .normal)
        authAudioBtn.imageView?.contentMode = .scaleAspectFit
        authAudioBtn.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        authAudioBtn.addTarget(self, action: #selector(audioAuth(_:)), for: .touchUpInside)
        authAudioBtn.createShadow(CGSize(width: 2, height: 2), 5)
        authAudioBtn.backgroundColor = .backgroundColor
        authAudioBtn.layer.cornerRadius = 20
        
        // 인증 수단 - 체크
        authCheckBtn.setImage(UIImage(named:"btnCheck"), for: .normal)
        authCheckBtn.imageView?.contentMode = .scaleAspectFit
        authCheckBtn.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        authCheckBtn.addTarget(self, action: #selector(authCheckButtonAction(_:)), for: .touchUpInside)
        authCheckBtn.createShadow(CGSize(width: 2, height: 2), 5)
        authCheckBtn.backgroundColor = .backgroundColor
        authCheckBtn.layer.cornerRadius = 20
        
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
        togetherFriendLabel.adjustsFontSizeToFitWidth = true
        togetherFriendLabel.text = "함께 도전 중인 친구"
        togetherFriendLabel.textAlignment = .left
        togetherFriendLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // 함께 도전 설명 라벨
        togetherExplainLabel.text = "* 친구를 초대 하고 함께 도전을 진행해 보세요!"
        togetherExplainLabel.textAlignment = .left
        togetherExplainLabel.adjustsFontSizeToFitWidth = true
        togetherExplainLabel.font = UIFont.italicSystemFont(ofSize: 15)
        togetherExplainLabel.textColor = .lightGray
        
        // 친구 추가 이미지 뷰 1
        friendImageView1.image = UIImage(named: "profileNon")
        friendImageView1.contentMode = .scaleAspectFit
        friendImageView1.layer.cornerRadius = self.view.frame.width * 0.2 / 2
        
        // 친구 추가 버튼1
        friendAddBtn1.setImage(UIImage(named:"btnAdd"), for: .normal)
        friendAddBtn1.backgroundColor = .subLightColor
        friendAddBtn1.layer.cornerRadius = self.view.frame.width * 0.2 / 2
        
        // 오늘 인증 라벨
        todayAuthLabel.text = "오늘 인증 현황"
        todayAuthLabel.textAlignment = .left
        todayAuthLabel.adjustsFontSizeToFitWidth = true
        todayAuthLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // 오늘 인증 콜렉션 뷰
        todayAuthCollectionView.delegate = self
        todayAuthCollectionView.dataSource = self
        todayAuthCollectionView.register(UINib(nibName: "TodoListDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodoListDetailCollectionViewCell")
        todayAuthCollectionView.backgroundColor = UIColor.backgroundColor
        todayAuthCollectionView.showsHorizontalScrollIndicator = false
        //todayAuthCollectionView.layer.borderColor = UIColor.black.cgColor
        //todayAuthCollectionView.layer.borderWidth = 1.0
        //todayAuthCollectionView.isPagingEnabled = true
        todayAuthCollectionView.bounces = false
        todayAuthCollectionView.decelerationRate = .normal
        
        // 위클리 리포트 라벨
        weeklyLabel.text = "위클리 리포트"
        weeklyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        weeklyLabel.textAlignment = .left
        weeklyLabel.adjustsFontSizeToFitWidth = true
        
        // 위클리 리포트 테이블 뷰
        weeklyTableView.register(UINib(nibName: "TodoListDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListDetailTableViewCell")
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        weeklyTableView.showsVerticalScrollIndicator = false
        weeklyTableView.isPagingEnabled = true
        weeklyTableView.backgroundColor = .backgroundColor
        weeklyTableView.separatorStyle = .none
        
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
        
        mondayNotiBtn = createNotiCircleBtn(type: .monday, to: cycleLabel, isFirst: true)
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
        btn.backgroundColor = .lightGrayColor
        btn.layer.cornerRadius = self.view.frame.width * 0.08 / 2
        
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
                make.top.equalTo(cycleLabel.snp.bottom).offset(20)
                make.leading.equalTo(self.view).offset(self.view.frame.width * 0.11)
            }
            else {
                make.top.equalTo(parent)
                make.leading.equalTo(parent.snp.trailing).offset(self.view.frame.width * 0.02)
            }
            make.width.equalTo(self.mainScrollView).multipliedBy(0.08)
            make.height.equalTo(selfBtn.snp.width)
        }
    }
    
}
