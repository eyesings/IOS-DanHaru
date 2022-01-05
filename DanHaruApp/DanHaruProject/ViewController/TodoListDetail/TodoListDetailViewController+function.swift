//
//  TodoListDetailViewController+function.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/09.
//

import Foundation
import UIKit
import AVFoundation
import UserNotifications

extension TodoListDetailViewController: AVAudioPlayerDelegate, AudioUIChangeProtocol, CheckDateChangeProtocol, CheckTimeChangeProtocol {
    
    func setUIValue() {
        
        self.titleText = self.detailInfoModel.encodedTitle ?? ""
        self.startDate = self.detailInfoModel.fr_date ?? ""
        self.endDate = self.detailInfoModel.ed_date ?? self.startDate
        
        if let detailModel = self.detailInfoModel.noti_time {
            self.noti_time = detailModel.isEmpty ? self.noti_time : detailModel
        }
        
        // 위클리 포스트
        if let report_list = self.detailInfoModel.report_list_percent {
            self.weeklyCount = report_list.count
            self.tableViewHeight = weeklyCount * Int(self.tableCellHeight)
            
            for name in report_list.keys {
                self.weekleyName.append(name)
            }
        }
        
        if let selected = self.detailInfoModel.noti_cycle?.components(separatedBy: ",") {
            var dayAppend: [DetailNotiDayBtnTag] = []
            selected.forEach { dayAppend.append(DetailNotiDayBtnTag.nameToSelf(val: $0)) }
            self.selectedNotiDay = dayAppend
        }
        self.cycleTimeLabel.isEnabled = !self.selectedNotiDay.isEmpty
        
        if let list = self.detailInfoModel?.certification_list {
            
            for i in 0 ..< list.count {
                /// 오늘 인증 내역 중에 내가 인증한 내역이 있을 때
                if list[i].mem_id == UserModel.memberId {
                    
                    self.isCurrAuth = true
                    
                }
                
            }
            
        }
        
    }
    
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
        
        self.mainScrollView.addSubview(authRegiArea)
        authRegiArea.snp.makeConstraints { make in
            make.top.equalTo(self.authCheckBtn.snp.bottom).offset(10)
            make.width.equalTo(screenwidth * 0.8)
            make.height.equalTo(0)
            make.centerX.equalTo(self.view)
        }
        
        // 오디오 인증 안함
        self.authRegiArea.addSubview(audioPlayArea)
        audioPlayArea.isHidden = true
        audioPlayArea.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.authRegiArea)
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
            make.width.equalTo(screenwidth * 0.1)
            make.trailing.equalTo(self.audioPlayTimeText.snp.leading)
        }
        audioPlayStopBtn.setImage(UIImage(named: "btnPlayCircle"), for: .normal)
        audioPlayStopBtn.imageView?.contentMode = .scaleAspectFit
        audioPlayStopBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        audioPlayStopBtn.addTarget(self, action: #selector(audioPlayStopButtonAction(_:)), for: .touchUpInside)
        
        self.audioPlayArea.addSubview(recordDeleteBtn)
        recordDeleteBtn.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(self.audioPlayStopBtn)
            make.leading.equalTo(self.audioPlayTimeText.snp.trailing)
        }
        recordDeleteBtn.setImage(#imageLiteral(resourceName: "btnTrash"), for: .normal)
        recordDeleteBtn.imageView?.contentMode = .scaleAspectFit
        recordDeleteBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        recordDeleteBtn.addTarget(self, action: #selector(audioDeleteButtonAction(_:)), for: .touchUpInside)
        
        self.authRegiArea.addSubview(authImageCollectionView)
        self.authImageCollectionView.isHidden = !(selectedImage.count > 0)
        //authImageCollectionView.isHidden = true
        authImageCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(authRegiArea)
        }
        
        self.authRegiArea.addSubview(checkAnimation)
        checkAnimation.isHidden = true
        checkAnimation.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(authRegiArea)
        }
        checkAnimation.animation = .named("check_black")
        checkAnimation.loopMode = .playOnce
        
        self.mainScrollView.addSubview(togetherFriendTitleLabel)
        togetherFriendTitleLabel.snp.makeConstraints { make in
            
            make.top.equalTo(self.authRegiArea.snp.bottom).offset(25)
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
        
        let collectionViewHeihgt = 180.0
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        self.todayAuthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.mainScrollView.addSubview(todayAuthCollectionView)
        
        self.mainScrollView.addSubview(inviteFriendBtn)
        
        guard let chalYN = self.detailInfoModel.chaluser_yn, chalYN == "Y" else {
            
            inviteFriendBtn.snp.remakeConstraints { make in
                make.width.height.equalTo(collectionViewHeihgt * 0.4)
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(todayAuthCollectionView)
            }
            
            todayAuthCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(togetherExplainLabel.snp.bottom)
                make.leading.equalTo(self.view.snp.trailing)
                make.height.equalTo(collectionViewHeihgt)
            }
            self.setLayout()
            return
        }
        
        inviteFriendBtn.snp.makeConstraints { make in
            make.width.height.equalTo(collectionViewHeihgt * 0.4)
            make.leading.equalTo(self.view).offset(20)
            make.centerY.equalTo(todayAuthCollectionView)
            make.trailing.equalTo(todayAuthCollectionView.snp.leading).offset(-10)
        }
        
        todayAuthCollectionView.snp.makeConstraints { make in
            make.top.equalTo(togetherExplainLabel.snp.bottom)
            make.trailing.equalTo(self.view)
            make.height.equalTo(collectionViewHeihgt)
        }
        
        self.mainScrollView.addSubview(notificationStateBtn)
        notificationStateBtn.snp.makeConstraints { make in
            make.centerY.equalTo(togetherFriendTitleLabel)
            make.leading.equalTo(togetherFriendTitleLabel.snp.trailing)
            make.height.equalTo(togetherFriendTitleLabel).multipliedBy(0.8)
            make.width.equalTo(notificationStateBtn.snp.height)
        }
        
        self.mainScrollView.addSubview(sendPushBtn)
        sendPushBtn.snp.makeConstraints { make in
            make.centerY.equalTo(notificationStateBtn)
            make.trailing.equalTo(self.view).offset(-10)
            make.height.equalTo(notificationStateBtn)
            make.width.equalTo(self.view).multipliedBy(0.25)
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
        startDateLabel.isUserInteractionEnabled = true
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
        endDateLabel.isUserInteractionEnabled = true
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
        cycleTimeLabel.isUserInteractionEnabled = true
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(circleTimeLabelAction(_:)))
        cycleTimeLabel.addGestureRecognizer(timeTap)
        
        // 인증 라벨
        authTitleLable.text = "인증 등록"
        customTitleLabelConfig(authTitleLable)
        
        // 인증 수단 - 이미지
        authImageBtn.setImage(UIImage(named: "btnPhotoAlbum"), for: .normal)
        authImageBtn.tag = DetailAuthBtnTag.image.rawValue
        authImageBtn.addTarget(self, action: #selector(onTapAuthBtnCommon(_:)), for: .touchUpInside)
        customButtonConfig(authImageBtn)
        
        // 인증 수단 - 오디오
        authAudioBtn.setImage(UIImage(named: "btnMic"), for: .normal)
        authAudioBtn.tag = DetailAuthBtnTag.audio.rawValue
        authAudioBtn.addTarget(self, action: #selector(onTapAuthBtnCommon(_:)), for: .touchUpInside)
        customButtonConfig(authAudioBtn)
        
        // 인증 수단 - 체크
        authCheckBtn.setImage(UIImage(named:"btnCheck"), for: .normal)
        authCheckBtn.tag = DetailAuthBtnTag.check.rawValue
        authCheckBtn.addTarget(self, action: #selector(onTapAuthBtnCommon(_:)), for: .touchUpInside)
        customButtonConfig(authCheckBtn)
        
        // 이미지 인증 CollectionView
        authImageCollectionView.delegate = self
        authImageCollectionView.dataSource = self
        authImageCollectionView.isScrollEnabled = false
        
        // 함께 도전 라벨
        togetherFriendTitleLabel.text = "함께 도전 중인 친구"
        customTitleLabelConfig(togetherFriendTitleLabel)
        
        // 함께 도전 설명 라벨
        togetherExplainLabel.text = "* 친구를 초대 하고 함께 도전을 진행해 보세요!"
        commonInfoLabelConfig(togetherExplainLabel)
        
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
        
        inviteFriendBtn.backgroundColor = .subLightColor
        inviteFriendBtn.setImage(UIImage(named: "btnAdd"), for: .normal)
        inviteFriendBtn.imageView?.contentMode = .scaleAspectFit
        inviteFriendBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        inviteFriendBtn.addTarget(self, action: #selector(inviteFriendWithSendSMS), for: .touchUpInside)
        
        // 인증한 이미지가 존재시
        //FIXME: 인증 수단 존재시에 따른 UI 변동 수정중
        showCertiAuth()
        
        guard let chalYN = self.detailInfoModel.chaluser_yn, chalYN == "Y" else {return }
        
        // 푸시 on/off 버튼
        notificationStateBtn.setImage(UIImage(named: "unmute"), for: .normal)
        notificationStateBtn.isSelected = true
        notificationStateBtn.addTarget(self, action: #selector(changeNotificationState), for: .touchUpInside)
        
        //FIXME: 푸시 보내기 버튼 수정중
        /*
        sendPushBtn.setTitle("재촉하기", for: .normal)
        sendPushBtn.setTitleColor(.black, for: .normal)
        sendPushBtn.layer.borderColor = UIColor.black.cgColor
        sendPushBtn.layer.borderWidth = 0.8
        sendPushBtn.layer.cornerRadius = 10
        sendPushBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        */
        sendPushBtn.setImage(UIImage(named: "btnSendPush"), for: .normal)
        sendPushBtn.imageView?.contentMode = .scaleAspectFit
        
        // 위클리 리포트 라벨
        weeklyTitleLabel.text = "위클리 리포트"
        customTitleLabelConfig(weeklyTitleLabel)
        
        // 위클리 리포트 테이블 뷰
        weeklyTableView.register(UINib(nibName: "TodoListDetailTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: TodoListDetailTableViewCell.reusableIdentifier)
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        weeklyTableView.showsVerticalScrollIndicator = false
        weeklyTableView.isPagingEnabled = true
        weeklyTableView.backgroundColor = .backgroundColor
        weeklyTableView.separatorStyle = .none
        weeklyTableView.createShadow(CGSize(width: 2, height: 2), 5)
        weeklyTableView.layer.masksToBounds = false
        
        // 디테일 뷰 작성자가 아니면 수정 못하게 막음
        if UserModel.memberId != self.detailInfoModel.created_user {
            titleTextField.isUserInteractionEnabled = false
            startDateLabel.isUserInteractionEnabled = false
            endDateLabel.isUserInteractionEnabled = false
            selectedNotiBtnList.forEach { $0.isUserInteractionEnabled = false }
            cycleTimeLabel.isUserInteractionEnabled = false
        }
    
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
        
        isRegisterAuth = true
        
        self.audioRecorder = audio
        
        self.audioPlayArea.isHidden = false
        self.regiAuthUpdate(isShow: true)
        
        if let recorder = self.audioRecorder {
            let audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
            
            if let player = audioPlayer {
                self.audioPlayTimeText.text = "\(RadHelper.convertNSTimeInterval12String(player.duration))"
            }
            
        }
        
    }
    
    func regiAuthUpdate(isShow: Bool) {
        self.authRegiArea.snp.remakeConstraints { make in
            make.top.equalTo(self.authCheckBtn.snp.bottom).offset(10)
            make.width.equalTo(screenwidth * 0.8)
            if isShow { make.height.equalTo(screenwidth * 0.3) }
            else { make.height.equalTo(0) }
            make.centerX.equalTo(self.view)
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
        //btn.backgroundColor = RadHelper.colorFromHex(hex: "dddddd")
        // 색상 일치 위해 수정 - 변경한 색상이 적합한지 확인 필요
        btn.backgroundColor = .lightGrayColor
        btn.layer.cornerRadius = self.view.frame.width * 0.09 / 2
        
        btn.layer.masksToBounds = true
        btn.tag = type.rawValue
        btn.addTarget(self, action: #selector(onTapDayNotiBtn(_:)), for: .touchUpInside)
        
        setLayoutNotiCircleBtn(with: btn, to: parent, isFirst: isFirst)
        
        // 선택한 반복주기가 있으면 선택 처리
        self.selectedNotiDay.forEach { tag in
            if btn.titleLabel?.text == tag.name() {
                btn.isSelected = true
                btn.backgroundColor = btn.isSelected ? .mainColor : .lightGrayColor
            }
        }
        
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
    
    // 오늘 인증 현황 그리는 함수
    func createCurrAuthCell(_ list: [ChallengeCertiModel],_ indexPath: IndexPath, _ cell: TodoListDetailCollectionViewCell) -> TodoListDetailCollectionViewCell {
        
        if indexPath.item == 0 {
            // FIXME: 첫번째에 로그인한 유저가 오게끔
            cell.personName.text = UserModel.profileName ?? (UserModel.memberId ?? "")
            RadHelper.getProfileImage { img in
                DispatchQueue.main.async {
                    cell.personImageView.image = img
                }
            }
            cell.authUserChangeUI(self.isRegisterAuth)
            //if self.isRegisterAuth { cell.personAuthBtn.setBackgroundImage(UIImage(named: "authCheck"), for: .normal) }
        } else if indexPath.item == 1 {
            // 로그인한 계정이 생성자가 아닐때, 두 번째 셀에는 생성자가 나올 수 있게
            if self.detailInfoModel.created_user != UserModel.memberId {
                
                cell.personName.text = self.detailInfoModel.challenge_user?[indexPath.item - 1].created_user ?? "생성자"
                
                if list.count > 0 {
                    
                    if list[indexPath.item-1].mem_id == self.detailInfoModel.challenge_user?[indexPath.item - 1].created_user {
                        if let certi_check = list[indexPath.item-1].certi_check {
                            certi_check.lowercased().contains("y") ? cell.authUserChangeUI(true) : cell.authUserChangeUI(false)
                        }
                    }
                    
                }
                
            } else {
                // 로그인한 계정이 생성자일시, 두 번째 셀에는 다른 유저들이 나올 수 있게
                cell.personName.text = self.detailInfoModel.challenge_user?[indexPath.item - 1].mem_id ?? "추가된 계정"
                
                if list.count > 0 {
                    for i in  0 ..< list.count {
                        if list[i].mem_id == self.detailInfoModel.challenge_user?[indexPath.item - 1].mem_id ?? "추가된 계정" {
                            if let certi_check = list[indexPath.item-1].certi_check {
                                certi_check.lowercased().contains("y") ? cell.authUserChangeUI(true) : cell.authUserChangeUI(false)
                            }
                        }
                    }
                
                }
                
            }
            
        } else {
            // 다른 유저들
            cell.personName.text = self.detailInfoModel.challenge_user?[indexPath.item - 1].mem_id ?? "추가된 계정들 이름"
            
            if list.count > 0 {
                if list[indexPath.item-2].mem_id == self.detailInfoModel.challenge_user?[indexPath.item-2].mem_id {
                    if let certi_check = list[indexPath.item-2].certi_check {
                        certi_check.lowercased().contains("y") ? cell.authUserChangeUI(true) : cell.authUserChangeUI(false)
                    }
                }
                
            }
            
        }
        
        return cell
    }
    
    func selectedNotiToStringArr() -> [String] {
        var strArr: [String] = []
        self.selectedNotiDay.forEach { daySelected in
            strArr.append(daySelected.name())
        }
        return strArr
    }
    
    /// 푸시 전송 함수
    func appendNotificationSchedule() {
        
        let timeFormmat = RadMessage.DateFormattor.timeDate
        if let endDateStr = self.endDateLabel.text,
           let selectedTime = self.cycleTimeLabel.text?.stringToDate(format: timeFormmat),
           let nowTime = Date().dateToStr(format: timeFormmat).stringToDate(format: timeFormmat),
           endDateStr == Date().dateToStr() {
            
            if (nowTime > selectedTime) {
                print("알림 등록되면 안됨")
                return
            }
        }
        
        func makeNotificationBody() -> String {
            if self.isForInviteFriend || self.detailInfoModel.chaluser_yn?.lowercased() == "y" {
                return "목표를 달성해요"
            } else {
                return "일정을 관리해요."
            }
        }
        
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "\(self.detailInfoModel.encodedTitle!)"
        notificationContent.body = "오늘도 단, 하루와 함께 \(makeNotificationBody())"
        notificationContent.userInfo = ["weblink":"danharu://pushopentodo?todoidx=\(self.detailInfoModel.todo_id!)"]
        notificationContent.categoryIdentifier = "dismissCategoryID"
        
        
        var notiSchedule: [DateComponents] = []
        
        if let timeArr = self.detailInfoModel.noti_time?.components(separatedBy: ":"),
           let hour = (timeArr.first as NSString?)?.integerValue,
           let minute = (timeArr.last as NSString?)?.integerValue {
            
            var dateComponent = DateComponents()
            dateComponent.calendar = Calendar.current
            
            if self.selectedNotiDay.contains(.everyday) {
                dateComponent.hour = hour
                dateComponent.minute = minute
                notiSchedule.append(dateComponent)
            } else {
                self.selectedNotiDay.forEach { selectedDay in
                    dateComponent.weekday = selectedDay.calendarWeekVal()
                    dateComponent.hour = hour
                    dateComponent.minute = minute
                    notiSchedule.append(dateComponent)
                }
            }
        }
        
        let notiRequestID = "\(UserModel.memberId!)_\(self.detailInfoModel.todo_id!)"
        UserDefaults.standard.updateNotiSchedule(endDate: self.endDateLabel.text ?? self.endDate, notiID: notiRequestID)
        
        for (i, dateComponent) in notiSchedule.enumerated() {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            let request = UNNotificationRequest(identifier: notiRequestID+"_\(i)",
                                                content: notificationContent,
                                                trigger: trigger)
            self.userNotificationCenter.add(request) { err in
                if let error = err { print("Notificaion Error  ", error) }
            }
        }
    }
    
    func showCertiAuth() {
        if self.selectedImage.count > 0 {
            self.regiAuthUpdate(isShow: true)
            self.authImageCollectionView.isHidden = false
            self.authImageCollectionView.reloadData()
        } else {
            // 인증 이미지가 없을시 - 단순 체크 또는 오디오 녹음
            if let list = self.detailInfoModel.certification_list {
                
                for i in 0 ..< list.count {
                    
                    if list[i].mem_id == UserModel.memberId {
                        // 인증 체크 확인
                        if let certi_check = list[i].certi_check {
                            // 단순 체크
                            if certi_check.lowercased().contains("y") && list[i].certi_voice == nil {
                                self.isRegisterAuth = true
                                self.isCheckAuth = true
                                self.regiAuthUpdate(isShow: true)
                                checkAnimation.isHidden = false
                                checkAnimation.play()
                            } else if certi_check.lowercased().contains("y") && list[i].certi_voice != nil {
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }
                
            }
        }
    }
    
}
