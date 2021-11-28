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

class TodoListDetailViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
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
    let audioProgressBar = UIProgressView()
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
    
    // 오디오 재생 관련
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    let timePlayerSelector: Selector = #selector(TodoListDetailViewController.updatePlayTime)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(_:)), name: Configs.NotificationName.audioRecordRemove, object: nil)
        
        // Do any additional setup after loading the view.
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

}



