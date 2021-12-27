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

protocol AudioUIChangeProtocol {
    func audioUIChange(_ audio: AVAudioRecorder?)
}

protocol CheckDateChangeProtocol {
    func dateChange(_ divisionCode: String, _ text: String)
}

protocol CheckTimeChangeProtocol {
    func timeChange(_ text:String)
}

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
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    /// 바텀 뷰 기본 높이 지정 변수
    internal var defaultHeight: CGFloat = 0
    
    var networkView: NetworkErrorView!
    
    /// 바텀 뷰 재사용 판단을 위한 변수
    var bottomViewType: BottomViewCheck = .todoAdd
    
    /// 이전 화면에서 날짜 받는 변수
    var preDate = "";
    
    var selectedTime = ""
    
    var bottomBtnBottomConst: NSLayoutConstraint!
    
    /// 바텀 뷰 UI 변수
    let bottomTitle = UILabel()
    let cancelBtn = UIButton()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
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
    var isBottomToCheck: Bool = false
    
    /// 프로토콜
    var audioDelegate: AudioUIChangeProtocol?
    var dateDelegate: CheckDateChangeProtocol?
    var timeDelegate: CheckTimeChangeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaultHeight = (bottomViewType == .todoAdd ? 350 : screenheight * 0.35) - 60
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground),
                                               name: Configs.NotificationName.didEnterBackground, object: nil)
        
        self.registerKeyboardNotification()
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showBottomSheet()
        }
    }
    
    override func viewDidLayoutSubviews() {
        titleTextField.makesToCustomField()
    }
    
    func setUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)

        dimmedView.alpha = 0.0
        
        dimmedView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.view)
        }
        
        commonInitBottomBtn(withTitle: self.bottomViewType.bottomBtnName(), isNeedCustomLayout: self.bottomViewType == .audioRecord)
        self.safeAreaView(topConst: self.bottomTodoAddBtn)
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.bottomTodoAddBtn.snp.top)
            make.height.equalTo(self.defaultHeight)
        }
        
        switch self.bottomViewType {
        case .todoAdd: setLayout(); break
        case .startDate, .endDate: setDateLayout(); break
        case .cycleTime: setCirCleTimeLayout(); break
        case .audioRecord: setAudioRecordLayout(); break
        }
        
        networkView = NetworkErrorView.shared
        networkView.delegate = self
        
    }

    

}


extension BottomSheetsViewController: NetworkErrorViewDelegate {
    func isNeedRetryService(_ type: APIType) {
        self.apiService(withType: type)
    }
    
    func apiService(withType type: APIType) {
        
        func showNetworkErrView(type: APIType) {
            self.networkView.showNetworkView()
            self.networkView.needRetryType = type
        }
        
        if type == .TodoCreate
        {
            let startDate = self.datePicker.date.dateToStr()
            let randomColor = UIColor().generateRandomBackgroundColor()
            _ = TodoResgisterViewModel(searchDate: startDate,
                                       inputTitle: self.titleTextField.text!.encodeEmoji(),
                                       color: randomColor.hexStringFromColor()) { showNetworkErrView(type: $0) }
        }
        
    }
}


// MARK: - Keyboard Protocol
extension BottomSheetsViewController: keyboardNotiRegistProtocol {
    func keyboardShowAndHide(_ notification: Notification) {
        RadHelper.keyboardAnimation(notification, bottomBtnBottomConst) {
            self.view.layoutIfNeeded()
        }
    }
}
