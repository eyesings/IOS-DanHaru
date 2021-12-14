//
//  BottomSheetsViewController+audio.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/26.
//

import UIKit
import SnapKit
import Lottie
import AVFoundation

extension BottomSheetsViewController {
    
    //MARK: - 오디오 인증 UI 함수
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: Configs.NotificationName.audioRecordContinue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(_:)), name: Configs.NotificationName.audioRecordRemove, object: nil)
        
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
            make.top.equalTo(self.recordTimeLabel.snp.bottom).offset(25)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.10)
            //make.height.equalTo(self.bottomSheetView).multipliedBy(0.06)
            make.height.equalTo(self.bottomSheetView.snp.width).multipliedBy(0.10)
            make.centerX.equalTo(self.bottomSheetView)
        }
        //recordStartBtn.setTitle("record", for: .normal)
        //recordStartBtn.setTitleColor(.blue, for: .normal)
        recordStartBtn.setImage(UIImage(named: "btnRedRecord"), for: .normal)
        recordStartBtn.addTarget(self, action: #selector(recordStartButtonAction(_:)), for: .touchUpInside)
        //recordStartBtn.imageView?.contentMode = .scaleAspectFit
        
        self.bottomSheetView.addSubview(recordPauseBtn)
        recordPauseBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordStartBtn)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.1)
            make.height.equalTo(self.bottomSheetView.snp.width).multipliedBy(0.1)
            make.centerX.equalTo(self.bottomSheetView)
        }
        recordPauseBtn.setImage(UIImage(named: "btnRedPause"), for: .normal)
        //recordPauseBtn.imageView?.contentMode = .scaleAspectFit
        recordPauseBtn.addTarget(self, action: #selector(recordPauseButtonAction(_:)), for: .touchUpInside)
        recordPauseBtn.isHidden = true
        
        
        self.bottomSheetView.addSubview(recordStopBtn)
        recordStopBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recordStartBtn)
            make.width.equalTo(self.recordStartBtn)
            make.height.equalTo(self.recordStartBtn)
            make.trailing.equalTo(self.recordStartBtn.snp.leading).offset(-self.view.frame.width * 0.1)
        }
        recordStopBtn.setImage(UIImage(named: "btnRedStop"), for: .normal)
        recordStopBtn.addTarget(self, action: #selector(recordStopButtonAction(_:)), for: .touchUpInside)
        recordStopBtn.isHidden = true
        
        
        self.bottomSheetView.addSubview(playStartBtn)
        playStartBtn.snp.makeConstraints { make in
            make.width.equalTo(self.recordStartBtn)
            make.height.equalTo(self.recordStartBtn)
            make.centerY.equalTo(self.recordStartBtn)
            make.left.equalTo(self.recordStartBtn.snp.right).offset(self.view.frame.width * 0.1)
        }
        playStartBtn.setImage(UIImage(named: "btnPlays"), for: .normal)
        playStartBtn.addTarget(self, action: #selector(playStartButtonAction(_:)), for: .touchUpInside)
        playStartBtn.isHidden = true
        
        self.bottomSheetView.addSubview(playStopBtn)
        playStopBtn.snp.makeConstraints { make in
            make.width.equalTo(self.recordStartBtn)
            make.height.equalTo(self.recordStartBtn)
            make.center.equalTo(self.playStartBtn)
        }
        playStopBtn.setImage(UIImage(named: "btnPauses"), for: .normal)
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
    
    //MARK: - 오디오 작동 함수
    /// 녹음 시작 함수
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
    
    /// 녹음 일시정지 함수
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
    
    /// 녹음 중지(완료) 함수
    @objc func recordStopButtonAction(_ sender: UIButton) {
        
        self.audioAnimation.stop()
        
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
    
    /// 녹음된 오디오 재생(단 녹음이 중지(완료)가 되어있어야 재생이 가능)
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
    
    /// 녹음된 오디오 재생 중지
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
    
    /// 녹음된 오디오 파일 저장(파일 앱에서 확인가능, 단 녹음이 중지(완료)가 되어야 할성화 )
    @objc func recordBottomTodoAddButtonAction(_ sender: UIButton) {
        // 녹음이 완료
        if self.isAudioFinish {
            // 저장 처리
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
            isBottomToCheck = true
            
            self.audioDelegate?.audioUIChange(self.audioRecorder)
            
            self.hideBottomSheetAndGoBack()
            
        }
        
    }
    
    /// 녹음이 중지(완료)가 되면 작동
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            // 녹음 완료 - stop 을 해야 녹음이 완료가 됨!!
            isAudioFinish = true
        }
        
    }
    
    /// 녹음 파일을 재생하고 재생이 종료되는 작동
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // 재생 종료
        print("재생 종료")
        self.audioAnimation.stop()
        self.playStopBtn.isHidden = true
        self.playStartBtn.isHidden = false
    }
    
    
    /// 오디오 녹음 시간 체크
    @objc func updateRecordTime() {
        if let recorder = audioRecorder {
            self.recordTimeLabel.text = RadHelper.convertNSTimeInterval12String(recorder.currentTime)
        }
    }
    
    //MARK: - 기본 함수
    /// 마이크 권한 체크 함수
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
    
    /// 녹음 도중 백그라운드 갔다오면 애니메이션이 멈추는 현상 수정
    @objc func applicationDidBecomeActive(_ notification:NSNotification) {
        
        if let recorder = self.audioRecorder {
            
            if recorder.isRecording {
                self.audioAnimation.play()
            }
            
        }
        
    }
    
    /// 앱 종료시 저장 중인 오디오 파일 삭제
    @objc func applicationWillTerminate(_ notification:NSNotification) {
        
        if let recorder = self.audioRecorder {
            
            do {
                try FileManager.default.removeItem(at: recorder.url)
            } catch _ {
                print("BottomSheetsView audio file remove failed")
            }
            
        }
        
    }
    
}
