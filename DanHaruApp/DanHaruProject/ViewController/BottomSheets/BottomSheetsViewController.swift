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
    var defaultHeight: CGFloat = 0.0
    
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
    let recordBtn = UIButton()
    let pauseBtn = UIButton()
    let stopBtn = UIButton()
    let playBtn = UIButton()
    let audioAnimation = AnimationView(name: "audio")
    let recodeTimeLabel = UILabel()
    
    /// 오디오 변수
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var soundURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaultHeight = self.view.frame.height / 2
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
        
        
        
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
        } else if checkShowUI == BottomViewCheck.audioRecode.rawValue {
            setAudioRecodeLayout()
        }
        
    }
    
    func setAudioRecodeLayout() {
        
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(25)
        }
        bottomTitle.text = "녹음 인증하기"
        bottomTitle.textAlignment = .center
        bottomTitle.textColor = .black
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 25)
        bottomTitle.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(audioAnimation)
        audioAnimation.snp.makeConstraints { make in
            make.top.equalTo(bottomTitle.snp.bottom)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.7)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.15)
            make.centerX.equalTo(self.bottomSheetView)
        }
        audioAnimation.play(toProgress: 0.0)
        //audioAnimation.play()
        audioAnimation.loopMode = .loop
        audioAnimation.contentMode = .scaleAspectFit
        
        self.bottomSheetView.addSubview(recodeTimeLabel)
        recodeTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.audioAnimation.snp.bottom)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.5)
            make.height.equalTo(15)
            make.centerX.equalTo(self.audioAnimation)
        }
        recodeTimeLabel.text = "00:00"
        recodeTimeLabel.adjustsFontSizeToFitWidth = true
        recodeTimeLabel.textAlignment = .center
        
        self.bottomSheetView.addSubview(recordBtn)
        recordBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recodeTimeLabel.snp.bottom).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.2)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.06)
            make.left.equalTo(self.bottomSheetView).offset(self.view.frame.width * 0.1)
        }
        recordBtn.setTitle("recode", for: .normal)
        recordBtn.setTitleColor(.blue, for: .normal)
        recordBtn.layer.borderWidth = 1.0
        recordBtn.layer.borderColor = UIColor.black.cgColor
        
        self.bottomSheetView.addSubview(pauseBtn)
        pauseBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordBtn)
            make.width.equalTo(self.recordBtn)
            make.height.equalTo(self.recordBtn)
            make.leading.equalTo(self.recordBtn.snp.trailing).offset(self.view.frame.width * 0.1)
        }
        pauseBtn.setTitle("pause", for: .normal)
        pauseBtn.setTitleColor(.blue, for: .normal)
        pauseBtn.layer.borderColor = UIColor.black.cgColor
        pauseBtn.layer.borderWidth = 1.0
        
        self.bottomSheetView.addSubview(stopBtn)
        stopBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordBtn)
            make.width.equalTo(self.recordBtn)
            make.height.equalTo(self.recordBtn)
            make.leading.equalTo(self.pauseBtn.snp.trailing).offset(self.view.frame.width * 0.1)
        }
        stopBtn.setTitle("stop", for: .normal)
        stopBtn.setTitleColor(.blue, for: .normal)
        stopBtn.layer.borderWidth = 1.0
        stopBtn.layer.borderColor = UIColor.black.cgColor
        
        
        self.bottomSheetView.addSubview(playBtn)
        playBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordBtn.snp.bottom).offset(10)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.height.equalTo(self.recordBtn)
            make.centerX.equalTo(self.bottomSheetView)
        }
        playBtn.setTitle("play", for: .normal)
        playBtn.setTitleColor(.blue, for: .normal)
        playBtn.layer.cornerRadius = 20
        playBtn.layer.borderColor = UIColor.black.cgColor
        playBtn.layer.borderWidth = 1.0
        
        
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView)
            //make.top.equalTo(self.playBtn.snp.bottom).offset(self.view.frame.height / 2 - self.view.frame.height * 0.27 - 180)
            make.bottom.equalTo(self.view)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("확인", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        
        
    }
    
    @objc func recordBtnAction(_ sender: UIButton) {
        
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                // 클릭후 플레이 버튼 이미지 설정
                
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
                
                recorder.record()
                
                
                
                
                
            } else {
                // pause
                
                recorder.pause()
                
                
                
            }
            
        }
        
    }
    
    @objc func stopButtonAction(_ sender: UIButton) {
        
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
        
//        let addData = MainViewController.dummyModel(title: titleText, date: startDate)
//
//        vc.tableData.append(addData)
        
        // FIXME: model add
        
        vc.todoListTableView.reloadData()
        
        self.hideBottomSheetAndGoBack()
        
    }
    
    @objc func bottomSheetDismiss(_ sender: UIButton) {
        self.hideBottomSheetAndGoBack()
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
