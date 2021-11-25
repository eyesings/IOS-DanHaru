//
//  BottomSheetsViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/28.
//

import UIKit
import SnapKit
import Lottie
import AVFoundation

class BottomSheetsViewController: UIViewController, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    /// 화면 딤 처리 부분
    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        return view
    }()
    /// UI 가 작성되는 뷰
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    /// 바텀 뷰 기본 높이 지정 변수
    var defaultHeight: CGFloat = 0
    
    /// 바텀 뷰 재사용 판단을 위한 변수
    var checkShowUI = "";
    
    /// 이전 화면에서 날짜 받는 변수
    var preDate = "";
    
    /// 바텀 뷰 UI 변수
    let bottomTitle = UILabel()
    let cancelBtn = UIButton()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let startDateLabel = UILabel()
    let datePicker = UIDatePicker()
    let bottomTodoAddBtn = UIButton()
    
    
    /// 오디오로 인증 UI 변수
    let recordStartBtn = UIButton()
    let recordStopBtn = UIButton()
    let recordPauseBtn = UIButton()
    let playStartBtn = UIButton()
    let playStopBtn = UIButton()
    let audioAnimation = AnimationView(name: "audio")
    let recordTimeLabel = UILabel()
    
    /// 오디오 변수
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var soundURL: String = ""
    let timeRecordSelector: Selector = #selector(BottomSheetsViewController.updateRecordTime)
    var progressTimer: Timer!
    var isAudioFinish: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.defaultHeight == 0 {
            self.defaultHeight = self.view.frame.height / 2
        }
        
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
        
        
        
        
        
        self.setUI()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
        
    }
    
    func setUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)

        dimmedView.alpha = 0.0
        
        dimmedView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(topConstant)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        if self.checkShowUI == BottomViewCheck.todoAdd.rawValue {
            setLayout()
        } else if checkShowUI == BottomViewCheck.startDate.rawValue || checkShowUI == BottomViewCheck.endDate.rawValue {
            setDateLayout()
        } else if checkShowUI == BottomViewCheck.cycleTime.rawValue {
            setCirCleTimeLayout()
        } else if checkShowUI == BottomViewCheck.audioRecord.rawValue {
            setAudioRecordLayout()
        }
        
    }
    
    func setAudioRecordLayout() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        } catch {
            print("audioSession Error")
        }
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileUrl = directoryURL!.appendingPathComponent(audioFileName)
        soundURL = audioFileName
        
        let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                       AVSampleRateKey: 44100.0,
                                       AVNumberOfChannelsKey: 2 ]
        
        audioRecorder = try? AVAudioRecorder(url: audioFileUrl, settings: recorderSetting)
        audioRecorder?.delegate = self
        audioPlayer?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        //audioRecorder?.prepareToRecord()
        
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.05)
        }
        bottomTitle.text = "녹음 인증하기"
        bottomTitle.textAlignment = .center
        bottomTitle.textColor = .black
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 20)
        bottomTitle.adjustsFontSizeToFitWidth = true
        bottomTitle.layer.borderWidth = 1.0
        bottomTitle.layer.borderColor = UIColor.black.cgColor
        
        self.bottomSheetView.addSubview(audioAnimation)
        audioAnimation.snp.makeConstraints { make in
            make.top.equalTo(bottomTitle.snp.bottom)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.7)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.1)
            make.centerX.equalTo(self.bottomSheetView)
        }
        audioAnimation.play(toProgress: 0.0)
        //audioAnimation.play()
        audioAnimation.loopMode = .loop
        audioAnimation.contentMode = .scaleAspectFit
        
        self.bottomSheetView.addSubview(recordTimeLabel)
        recordTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.audioAnimation.snp.bottom)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.5)
            make.height.equalTo(15)
            make.centerX.equalTo(self.audioAnimation)
        }
        recordTimeLabel.text = "00:00"
        recordTimeLabel.adjustsFontSizeToFitWidth = true
        recordTimeLabel.textAlignment = .center
        
        self.bottomSheetView.addSubview(recordStartBtn)
        recordStartBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordTimeLabel.snp.bottom).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.2)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.06)
            make.centerX.equalTo(self.bottomSheetView)
        }
        recordStartBtn.setTitle("record", for: .normal)
        recordStartBtn.setTitleColor(.blue, for: .normal)
        recordStartBtn.layer.borderWidth = 1.0
        recordStartBtn.layer.borderColor = UIColor.black.cgColor
        recordStartBtn.addTarget(self, action: #selector(recordStartButtonAction(_:)), for: .touchUpInside)
        
        self.bottomSheetView.addSubview(recordPauseBtn)
        recordPauseBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordTimeLabel.snp.bottom).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.2)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.06)
            make.centerX.equalTo(self.bottomSheetView)
        }
        recordPauseBtn.setTitle("pause", for: .normal)
        recordPauseBtn.setTitleColor(.blue, for: .normal)
        recordPauseBtn.layer.borderWidth = 1.0
        recordPauseBtn.layer.borderColor = UIColor.black.cgColor
        recordPauseBtn.addTarget(self, action: #selector(recordPauseButtonAction(_:)), for: .touchUpInside)
        recordPauseBtn.isHidden = true
        
        
        self.bottomSheetView.addSubview(recordStopBtn)
        recordStopBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordStartBtn)
            make.width.equalTo(self.recordStartBtn)
            make.height.equalTo(self.recordStartBtn)
            make.trailing.equalTo(self.recordStartBtn.snp.leading).offset(-self.view.frame.width * 0.1)
        }
        recordStopBtn.setTitle("stop", for: .normal)
        recordStopBtn.setTitleColor(.blue, for: .normal)
        recordStopBtn.layer.cornerRadius = 20
        recordStopBtn.layer.borderColor = UIColor.black.cgColor
        recordStopBtn.layer.borderWidth = 1.0
        recordStopBtn.addTarget(self, action: #selector(recordStopButtonAction(_:)), for: .touchUpInside)
        recordStopBtn.isHidden = true
        
        
        self.bottomSheetView.addSubview(playStartBtn)
        playStartBtn.snp.makeConstraints { make in
            make.width.equalTo(self.recordStartBtn)
            make.height.equalTo(self.recordStartBtn)
            make.centerY.equalTo(self.recordStartBtn)
            make.left.equalTo(self.recordStartBtn.snp.right).offset(self.view.frame.width * 0.1)
        }
        playStartBtn.setTitle("play", for: .normal)
        playStartBtn.setTitleColor(.blue, for: .normal)
        playStartBtn.layer.cornerRadius = 20
        playStartBtn.layer.borderColor = UIColor.black.cgColor
        playStartBtn.layer.borderWidth = 1.0
        playStartBtn.addTarget(self, action: #selector(playStartButtonAction(_:)), for: .touchUpInside)
        playStartBtn.isHidden = true
        
        self.bottomSheetView.addSubview(playStopBtn)
        playStopBtn.snp.makeConstraints { make in
            make.width.equalTo(self.recordStartBtn)
            make.height.equalTo(self.recordStartBtn)
            make.center.equalTo(self.playStartBtn)
        }
        playStopBtn.setTitle("pause", for: .normal)
        playStopBtn.setTitleColor(.blue, for: .normal)
        playStopBtn.layer.cornerRadius = 20
        playStopBtn.layer.borderColor = UIColor.black.cgColor
        playStopBtn.layer.borderWidth = 1.0
        playStopBtn.addTarget(self, action: #selector(playStopButtonAction(_:)), for: .touchUpInside)
        playStopBtn.isHidden = true
        
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView)
            make.bottom.equalTo(self.view)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("확인", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        bottomTodoAddBtn.addTarget(self, action: #selector(recordBottomTodoAddButtonAction(_:)), for: .touchUpInside)
        
        self.checkMicrophoneAccess()
        
    }
    
    @objc func recordBottomTodoAddButtonAction(_ sender: UIButton) {
        // 녹음이 완료
        if self.isAudioFinish {
            // 저장 처리
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //let audioFileName = UUID().uuidString + ".m4a"
            let audioFileUrl = directoryURL.appendingPathComponent(soundURL)
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            } catch _ {
                
            }
            
            let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                           AVSampleRateKey: 44100.0,
                                           AVNumberOfChannelsKey: 2 ]

            
            audioRecorder = try? AVAudioRecorder(url: audioFileUrl, settings: recorderSetting)
            
            let preVc = self.presentingViewController
            guard let vc = preVc as? TodoListDetailViewController else { return }
            vc.audioPlayer = self.audioPlayer
            vc.audioRecorder = self.audioRecorder
            
            
            self.hideBottomSheetAndGoBack()
            
        }
        
        
    }
    
    @objc func recordStartButtonAction(_ sender: UIButton) {
        
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                } catch _ {
                    print("audio active failed")
                }
                recordStartBtn.isHidden = true
                recordPauseBtn.isHidden = false
                recordStopBtn.isHidden = false
                playStartBtn.isHidden = true
                playStopBtn.isHidden = true
                recorder.record()
                isAudioFinish = false
                progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
                self.audioAnimation.play()
            }
            
        }
        
    }
    
    @objc func recordPauseButtonAction(_ sender: UIButton) {
        
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        
        if let recorder = audioRecorder {
            if recorder.isRecording {
                recordPauseBtn.isHidden = true
                recordStartBtn.isHidden = false
                recorder.pause()
                //recorder.stop()
                self.audioAnimation.stop()
                
            }
            
        }
        
    }
    
    @objc func recordStopButtonAction(_ sender: UIButton) {
        
        self.audioAnimation.stop()
        
        // stop the audio player if playing
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        
        if let recorder = audioRecorder {
            recorder.stop()
            progressTimer.invalidate()
            playStartBtn.isHidden = false
            recordPauseBtn.isHidden = true
            recordStartBtn.isHidden = false
            recordStopBtn.isHidden = true
        }
        
        
    }
    
    @objc func playStartButtonAction(_ sender: UIButton) {
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                //print("audio playing")
                audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                
                audioPlayer?.delegate = self
                audioPlayer?.play()
                audioAnimation.play()
                playStartBtn.isHidden = true
                playStopBtn.isHidden = false
            }
            
        }
        
    }
    
    @objc func playStopButtonAction(_ sender: UIButton) {
        
        if let recorder = audioRecorder {
            
            if !recorder.isRecording {
                //print("audio stop")
                audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                audioPlayer?.delegate = self
                audioPlayer?.stop()
                audioAnimation.stop()
                playStartBtn.isHidden = false
                playStopBtn.isHidden = true
            }
            
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            // 녹음 완료 - stop 을 해야 녹음이 완료가 됨!!
            isAudioFinish = true
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // 재생 종료
        print("재생 종료")
        self.audioAnimation.stop()
        self.playStopBtn.isHidden = true
        self.playStartBtn.isHidden = false
    }
    
    
    @objc func bottomTodoCheckTime(_ sender: UIButton) {
        //print("시간 \(self.datePicker.date)")
        Configs.formatter.dateFormat = "HH:mm"
        let changeTime = Configs.formatter.string(from: self.datePicker.date)
        
        let preVc = self.presentingViewController
        guard let vc = preVc as? TodoListDetailViewController else { return }
        vc.cycleTimeLabel.text = "\(changeTime)"
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func bottomTodoCheckDate(_ sender: UIButton) {
        
        let preVc = self.presentingViewController
        guard let vc = preVc as? TodoListDetailViewController else { return }
        
        Configs.formatter.dateFormat = "yyyy-MM-dd"
        let changeDate = Configs.formatter.string(from: self.datePicker.date)
        
        if self.checkShowUI == BottomViewCheck.startDate.rawValue {
            vc.startDateLabel.text = changeDate
        } else if self.checkShowUI == BottomViewCheck.endDate.rawValue {
            vc.endDateLabel.text = changeDate
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
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
    
    @objc func bottomTodoAddAction(_ sender: UIButton) {
        
        let titleText = self.titleTextField.text
        let startDate = self.datePicker.date
        
        let preVc = RadHelper.getMainViewController()
        guard let vc = preVc as? MainViewController else { return }
        
        // FIXME: - 타이틀을 입력 안하면 처리
        if titleText == "" {
            
            return;
        }
        
        let addData = MainViewController.dummyModel(title: titleText, date: startDate)
        
        vc.tableData.append(addData)
        
        vc.todoListTableView.reloadData()
        
        self.hideBottomSheetAndGoBack()
        
    }
    
    @objc func bottomSheetDismiss(_ sender: UIButton) {
        self.hideBottomSheetAndGoBack()
    }
    
    @objc func updateRecordTime() {
        if let recorder = audioRecorder {
            self.recordTimeLabel.text = convertNSTimeInterval12String(recorder.currentTime)
        }
    }
    
    func convertNSTimeInterval12String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    func checkMicrophoneAccess() {
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            Dprint("record permission grandted")
            break
        case .denied:
            print("record permission denied")
            RadAlertViewController.alertControllerShow(WithTitle: RadMessage.basicTitle, message: RadMessage.Permission.permissionDenied, isNeedCancel: true, viewController: self) { check in
                
                if check {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                    }
                    
                } else {
                    
                    self.recordStartBtn.isEnabled = false
                    self.bottomTodoAddBtn.isEnabled = false
                }
            }
            break
        case .undetermined:
            
            AVAudioSession.sharedInstance().requestRecordPermission { grandted in
                
                if grandted {
                    Dprint("record permission grandted")
                } else {
                    Dprint("record permission denied")
                    self.hideBottomSheetAndGoBack()
                }
                
            }
            
        @unknown default:
            Dprint("record permission default")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
