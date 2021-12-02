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
    let menuBtn = UIButton()
    let bottomBtn = UIButton()
    
    // 제목
    let titleTextField = UITextField()
    
    // 기간 선택
    let durationLabel = UILabel()
    let startDateView = UIView()
    let endDateView = UIView()
    let startDateLabel = UILabel()
    let endDateLabel = UILabel()
    let middleLabel = UILabel()
    
    // 반복주기
    let cycleLabel = UILabel()
    let cycleExplainLabel = UILabel()
    let circleBtn1 = UIButton()
    let circleBtn2 = UIButton()
    let circleBtn3 = UIButton()
    let circleBtn4 = UIButton()
    let circleBtn5 = UIButton()
    let circleBtn6 = UIButton()
    let circleBtn7 = UIButton()
    let circleBtn8 = UIButton()
    let cycleTimeLabel = UILabel()
    
    // 인증 수단
    let authLable = UILabel()
    let authImageBtn = UIButton()
    let authImageBackView = UIView()
    let authAudioBtn = UIButton()
    let authAudioBackView = UIView()
    let authCheckBackView = UIView()
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
    let togetherFriendLabel = UILabel()
    let togetherExplainLabel = UILabel()
    let friendImageView1 = UIImageView()
    let friendAddBtn1 = UIButton()
    let friendImageView2 = UIImageView()
    let friendAddBtn2 = UIButton()
    
    // 오늘 인증 현황
    let todayAuthLabel = UILabel()
    var todayAuthCollectionView: UICollectionView!
    
    // 위클리 리포트
    let weeklyLabel = UILabel()
    let weeklyTableView = UITableView()
    
    //클릭 요일
    var circleCheckDay: [String] = []
    
    // 메인 스크롤 뷰
    let mainScrollView = UIScrollView()
    
    var titleText: String = "";
    
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
    var weeklyCount = 7 // 추가한 친구 갯수
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewHeight = weeklyCount * Int(self.tableCellHeight)
        
        self.setUI()
        
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
        self.startDateView.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.endDateView.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.cycleTimeLabel.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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



