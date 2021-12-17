//
//  TodoListDetailViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/29.
//

import UIKit
import SnapKit
import Lottie
import AVFoundation

class TodoListDetailViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // 상단, 하단 버튼
    let backBtn = UIButton()
    let bottomBtn = UIButton()
    
    // 제목
    let titleTextField = UITextField()
    
    // 기간 선택
    let durationTitleLabel = UILabel()
    let startDateLabel = UILabel()
    let endDateLabel = UILabel()
    let middleLabel = UILabel()
    
    // 반복주기
    let cycleTitleLabel = UILabel()
    let cycleExplainLabel = UILabel()
    var mondayNotiBtn = UIButton()
    var selectedNotiBtnList: [UIButton] = []
    let cycleTimeLabel = UILabel()
    
    // 인증 수단
    let authTitleLable = UILabel()
    let authImageBtn = UIButton()
    let authAudioBtn = UIButton()
    let authCheckBtn = UIButton()
    
    let audioPlayArea = UIView()
    var audioPlayTimeText = UILabel()
    let audioPlayStopBtn = UIButton()
    let recordDeleteBtn = UIButton()
    
    let authImageView1 = UIImageView()
    let authImageView2 = UIImageView()
    let authImageView3 = UIImageView()
    
    let imageDeleteBtn1 = UIButton()
    let imageDeleteBtn2 = UIButton()
    let imageDeleteBtn3 = UIButton()
    
    // 함께 도전 중인 친구
    let togetherFriendTitleLabel = UILabel()
    let togetherExplainLabel = UILabel()
    let togetherFriendCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.register(UINib(nibName: "ChallengeFriendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ChallengeFriendCollectionViewCell.reusableIdentifier)
        collectionView.tag = DetailCollectionViewTag.challFriend.rawValue
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    let inviteFriendBtn = UIButton()
    
    // 오늘 인증 현황
    let todayAuthTitleLabel = UILabel()
    var todayAuthCollectionView: UICollectionView!
    let notificationStateBtn = UIButton()
    
    // 위클리 리포트
    let weeklyTitleLabel = UILabel()
    let weeklyTableView = UITableView()
    
    //클릭 요일
    var selectedNotiDay: [String] = []
    
    // 메인 스크롤 뷰
    let mainScrollView = UIScrollView()
    
    var currentIdx: CGFloat = 0.0
    
    var isForInviteFriend: Bool = false
    var invitedMemId: String?
    var detailInfoModel: TodoModel?
    
    // 오디오 재생 관련
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    let timeRecordSelector: Selector = #selector(TodoListDetailViewController.updateRecordTime)
    var progressTimer: Timer!
    
    // 위클리 데이트 프로그래스 바 색깔
    var todoListCellBackGroundColor: [UIColor] = [
        UIColor.todoLightBlueColor,
        UIColor.todoLightGreenColor,
        UIColor.todoLightYellowColor,
        UIColor.todoHotPickColor
    ]
    
    let imagePicker = UIImagePickerController()
    
    // 인증 수단 체크
    var isImageAuth = false
    var isAudioAuth = false
    var isCheckAuth = false
    
    // 테이블 뷰
    var tableViewHeight = 0
    let tableCellHeight: CGFloat = 40
    var weeklyCount = 0 // 추가한 친구 갯수
    
    // 단순 체크 애니메이션
    let checkAnimation = AnimationView()
    
    // 화면 UI 변수
    var titleText: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var noti_time: String = ""
    
    var weekleyName: [String] = []
    var weekleyPercent: [Float] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// UI 변수 값들 - 추후 함수로 정리
        self.titleText = self.detailInfoModel?.title ?? ""
        self.startDate = self.detailInfoModel?.fr_date ?? ""
        self.endDate = self.detailInfoModel?.ed_date ?? ""
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        self.noti_time = self.detailInfoModel?.noti_time ?? "\(hour) : 00"
        

        if let report_list = self.detailInfoModel?.report_list_percent {
            self.weeklyCount = report_list.count
            self.tableViewHeight = weeklyCount * Int(self.tableCellHeight)
            
            for name in report_list.keys {
                self.weekleyName.append(name)
            }
            
        }
        
        
        self.setUI()
        self.safeAreaView(topConst: bottomBtn)
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        self.titleTextField.delegate = self
        
        /// 스크롤 뷰는 제스처 추가로 화면 터치시 키보드 숨김 처리를 해결해야 함
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardHide(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        mainScrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        /// 스크롤시 키보드 숨김 처리
        mainScrollView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(_:)), name: Configs.NotificationName.audioRecordRemove, object: nil)
        
        // Do any additional setup after loading the view.
        
        guard let rootVC = RadHelper.getRootViewController() else { return }
        rootVC.hideLoadingView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.titleTextField.makesToCustomField()
        self.startDateLabel.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.endDateLabel.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.cycleTimeLabel.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.inviteFriendBtn.layer.cornerRadius = inviteFriendBtn.frame.width / 2
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == titleTextField {
            titleTextField.resignFirstResponder()
        }
        
        return true
    }
    
    /// 화면 터치시 키보드 숨김
    @objc func tapKeyboardHide(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /// 화면 드래그시 키보드 숨김
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}



