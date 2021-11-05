//
//  TodoListDetailViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/29.
//

import UIKit
import SnapKit
import Lottie

class TodoListDetailViewController: UIViewController {
    
    

    let backBtn = UIButton()
    let menuBtn = UIButton()
    let bottomBtn = UIButton()
    let titleTextField = UITextField()
    let durationLabel = UILabel()
    let startDateView = UIView()
    let endDateView = UIView()
    let startDateLabel = UILabel()
    let endDateLabel = UILabel()
    let middleLabel = UILabel()
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
    let authLable = UILabel()
    let authImageBtn = UIButton()
    let authImageBackView = UIView()
    let authAudioBtn = UIButton()
    let authAudioBackView = UIView()
    let authCheckBackView = UIView()
    let authCheckBtn = UIButton()
    
    let audioPlayArea = UIView()
    
    let authImageView1 = UIImageView()
    let authImageView2 = UIImageView()
    let authImageView3 = UIImageView()
    
    let togetherFriendLabel = UILabel()
    let togetherExplainLabel = UILabel()
    
    let friendImageView1 = UIImageView()
    let friendAddBtn1 = UIButton()
    
    let friendImageView2 = UIImageView()
    let friendAddBtn2 = UIButton()
    
    let todayAuthLabel = UILabel()
    var todayAuthCollectionView: UICollectionView!
    
    
    // 스크롤 작동을 위해 임시로 추가한 라벨
    let bottomTestLabel = UILabel()
    
    //클릭 요일
    var circleCheckDay: [String] = []
    
    let mainScrollView = UIScrollView()
    
    var titleText : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    // FIXME: UI 작성중
    func setUI() {
        self.view.backgroundColor = .backgroundColor
        
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(self.view).offset(10)
            make.height.equalTo(self.view).multipliedBy(0.05)
            make.width.equalTo(self.view).multipliedBy(0.08)
        }
        backBtn.setImage(#imageLiteral(resourceName: "btnArrowLeft"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(menuBtn)
        menuBtn.snp.makeConstraints { make in
            make.top.equalTo(self.backBtn)
            make.width.equalTo(self.backBtn)
            make.trailing.equalTo(self.view).offset(-20)
            make.height.equalTo(self.backBtn)
        }
        menuBtn.setImage(#imageLiteral(resourceName: "btnEdit"), for: .normal)
        
        self.view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.width.equalTo(self.view)
            make.height.equalTo(60)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        bottomBtn.setTitle("확인", for: .normal)
        bottomBtn.backgroundColor = .lightGrayColor
        bottomBtn.setTitleColor(.white, for: .normal)
        
        self.view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.backBtn.snp.bottom)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.bottomBtn.snp.top)
            make.width.equalTo(self.view)
        }
        mainScrollView.backgroundColor = .backgroundColor
        mainScrollView.showsVerticalScrollIndicator = false
        
        self.mainScrollView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.mainScrollView).offset(10)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.7)
            make.height.equalTo(40)
            make.leading.equalTo(self.mainScrollView).offset(20)
        }
        titleTextField.text = titleText;
        titleTextField.adjustsFontSizeToFitWidth = true
        titleTextField.textAlignment = .left
        titleTextField.font = UIFont.boldSystemFont(ofSize: 25)
        titleTextField.makesToCustomField()
        
        self.mainScrollView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleTextField.snp.bottom).offset(10)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.5)
            make.height.equalTo(30)
            make.leading.equalTo(self.titleTextField)
        }
        durationLabel.text = "기간 선택"
        durationLabel.adjustsFontSizeToFitWidth = true
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.mainScrollView.addSubview(startDateView)
        startDateView.snp.makeConstraints { make in
            make.top.equalTo(self.durationLabel.snp.bottom).offset(10)
            make.width.equalTo(self.view).multipliedBy(0.35)
            make.height.equalTo(40)
            make.leading.equalTo(self.durationLabel)
        }
        startDateView.backgroundColor = .backgroundColor
        startDateView.alpha = 0.5
        
        
        self.startDateView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.startDateView)
            make.width.equalTo(self.startDateView)
            make.height.equalTo(self.startDateView)
            make.bottom.equalTo(self.startDateView)
            make.leading.equalTo(self.startDateView)
        }
        Configs.formatter.dateFormat = "yyyy-MM-dd"
        let startDate = Configs.formatter.string(from: Date())
        
        startDateLabel.text = "\(startDate)"
        startDateLabel.textColor = .black
        startDateLabel.textAlignment = .center
        startDateLabel.adjustsFontSizeToFitWidth = true
        startDateLabel.isUserInteractionEnabled = true
        startDateLabel.tag = 1111
        let startTap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        startDateLabel.addGestureRecognizer(startTap)
        
        self.mainScrollView.addSubview(middleLabel)
        middleLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel)
            make.centerX.equalTo(self.view)
            make.height.equalTo(startDateLabel)
            make.leading.equalTo(startDateLabel.snp.trailing).offset(self.mainScrollView.frame.width * 0.1)
        }
        middleLabel.text = "~"
        middleLabel.adjustsFontSizeToFitWidth = true
        middleLabel.textColor = .black
        middleLabel.textAlignment = .center
        
        self.mainScrollView.addSubview(endDateView)
        endDateView.snp.makeConstraints { make in
            make.top.equalTo(startDateView)
            make.width.equalTo(startDateView)
            make.height.equalTo(startDateView)
            make.leading.equalTo(middleLabel.snp.trailing).offset(self.mainScrollView.frame.width * 0.1)
        }
        endDateView.backgroundColor = .backgroundColor
        endDateView.alpha = 0.5
        
        self.endDateView.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.top.equalTo(endDateView)
            make.bottom.equalTo(endDateView)
            make.width.equalTo(endDateView)
            make.height.equalTo(endDateView)
        }
        Configs.formatter.dateFormat = "yyyy-MM-dd"
        let tomorrow = Date().addingTimeInterval(86400)
        let endDate = Configs.formatter.string(from: tomorrow)
        
        endDateLabel.text = "\(endDate)"
        endDateLabel.textColor = .black
        endDateLabel.textAlignment = .center
        endDateLabel.isUserInteractionEnabled = true
        endDateLabel.adjustsFontSizeToFitWidth = true
        let endTap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        endDateLabel.addGestureRecognizer(endTap)
        
        self.mainScrollView.addSubview(cycleLabel)
        cycleLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateView.snp.bottom).offset(20)
            make.leading.equalTo(durationLabel)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.2)
            make.height.equalTo(durationLabel)
        }
        cycleLabel.text = "주기 선택"
        cycleLabel.textAlignment = .left
        cycleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cycleLabel.adjustsFontSizeToFitWidth = true
        cycleLabel.textColor = .black
        
        self.mainScrollView.addSubview(cycleExplainLabel)
        cycleExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(cycleLabel)
            make.height.equalTo(cycleLabel)
            make.leading.equalTo(cycleLabel.snp.trailing).offset(5)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.6)
        }
        cycleExplainLabel.text = "* 선택 한 주기마다 알림이 전송 됩니다."
        cycleExplainLabel.textAlignment = .left
        cycleExplainLabel.adjustsFontSizeToFitWidth = true
        cycleExplainLabel.font = UIFont.italicSystemFont(ofSize: 15)
        cycleExplainLabel.textColor = UIColor.lightGrayColor
        
        self.mainScrollView.addSubview(circleBtn1)
        circleBtn1.snp.makeConstraints { make in
            make.top.equalTo(cycleLabel.snp.bottom).offset(20)
            make.leading.equalTo(self.mainScrollView).offset(self.view.frame.width * 0.03)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn1.setTitle("월", for: .normal)
        circleBtn1.setTitleColor(.black, for: .normal)
        circleBtn1.backgroundColor = .lightGrayColor
        circleBtn1.alpha = 0.5
        circleBtn1.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn1.layer.masksToBounds = true
        circleBtn1.tag = 111
        circleBtn1.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(circleBtn2)
        circleBtn2.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn1.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn2.setTitle("화", for: .normal)
        circleBtn2.setTitleColor(.black, for: .normal)
        circleBtn2.backgroundColor = .lightGrayColor
        circleBtn2.alpha = 0.5
        circleBtn2.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn2.layer.masksToBounds = true
        circleBtn2.tag = 222
        circleBtn2.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(circleBtn3)
        circleBtn3.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn2.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn3.setTitle("수", for: .normal)
        circleBtn3.setTitleColor(.black, for: .normal)
        circleBtn3.backgroundColor = .lightGrayColor
        circleBtn3.alpha = 0.5
        circleBtn3.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn3.layer.masksToBounds = true
        circleBtn3.tag = 333
        circleBtn3.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(circleBtn4)
        circleBtn4.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn3.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn4.setTitle("목", for: .normal)
        circleBtn4.setTitleColor(.black, for: .normal)
        circleBtn4.backgroundColor = .lightGrayColor
        circleBtn4.alpha = 0.5
        circleBtn4.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn4.layer.masksToBounds = true
        circleBtn4.tag = 444
        circleBtn4.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(circleBtn5)
        circleBtn5.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn4.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn5.setTitle("금", for: .normal)
        circleBtn5.setTitleColor(.black, for: .normal)
        circleBtn5.backgroundColor = .lightGrayColor
        circleBtn5.alpha = 0.5
        circleBtn5.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn5.layer.masksToBounds = true
        circleBtn5.tag = 555
        circleBtn5.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(circleBtn6)
        circleBtn6.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn5.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn6.setTitle("토", for: .normal)
        circleBtn6.setTitleColor(.black, for: .normal)
        circleBtn6.backgroundColor = .lightGrayColor
        circleBtn6.alpha = 0.5
        circleBtn6.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn6.layer.masksToBounds = true
        circleBtn6.tag = 666
        circleBtn6.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        
        self.mainScrollView.addSubview(circleBtn7)
        circleBtn7.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn6.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn7.setTitle("일", for: .normal)
        circleBtn7.setTitleColor(.black, for: .normal)
        circleBtn7.backgroundColor = .lightGrayColor
        circleBtn7.alpha = 0.5
        circleBtn7.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn7.layer.masksToBounds = true
        circleBtn7.tag = 777
        circleBtn7.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(circleBtn8)
        circleBtn8.snp.makeConstraints { make in
            make.top.equalTo(circleBtn1)
            make.leading.equalTo(circleBtn7.snp.trailing).offset(self.view.frame.width * 0.02)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.1)
            make.height.equalTo(self.view.frame.width * 0.1)
        }
        circleBtn8.setTitle("매일", for: .normal)
        circleBtn8.setTitleColor(.black, for: .normal)
        circleBtn8.backgroundColor = .lightGrayColor
        circleBtn8.alpha = 0.5
        circleBtn8.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        circleBtn8.layer.masksToBounds = true
        circleBtn8.tag = 888
        circleBtn8.addTarget(self, action: #selector(circleBtnAction(_:)), for: .touchUpInside)
        
        self.mainScrollView.addSubview(cycleTimeLabel)
        cycleTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.circleBtn1.snp.bottom).offset(25)
            make.width.equalTo(self.mainScrollView).multipliedBy(0.4)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
        }
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        cycleTimeLabel.text = "\(hour) : 00"
        cycleTimeLabel.textAlignment = .center
        cycleTimeLabel.textColor = .black
        cycleTimeLabel.adjustsFontSizeToFitWidth = true
        cycleTimeLabel.font = UIFont.italicSystemFont(ofSize: 20)
        cycleTimeLabel.isUserInteractionEnabled = true
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(circleTimeLabelAction(_:)))
        cycleTimeLabel.addGestureRecognizer(timeTap)
        
        self.mainScrollView.addSubview(authLable)
        authLable.snp.makeConstraints { make in
            make.top.equalTo(cycleTimeLabel.snp.bottom).offset(25)
            make.leading.equalTo(durationLabel)
            make.height.equalTo(durationLabel)
            make.width.equalTo(durationLabel)
        }
        authLable.text = "인증 등록"
        authLable.textAlignment = .left
        authLable.font = UIFont.boldSystemFont(ofSize: 20)
        authLable.textColor = UIColor.black
        authLable.adjustsFontSizeToFitWidth = true
        
        self.mainScrollView.addSubview(authImageBackView)
        authImageBackView.snp.makeConstraints { make in
            make.top.equalTo(authLable.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view.frame.width * 0.2)
            make.left.equalTo(self.view).offset(self.view.frame.width * 0.1)
        }
        authImageBackView.layer.borderColor = UIColor.lightGray.cgColor
        authImageBackView.layer.borderWidth = 1
        authImageBackView.layer.shadowColor = UIColor.black.cgColor
        authImageBackView.layer.shadowOpacity = 0.7
        authImageBackView.layer.shadowOffset = CGSize(width: 2, height: 2)
        authImageBackView.layer.shadowRadius = 5
        authImageBackView.layer.cornerRadius = 20
        authImageBackView.backgroundColor = .white
        
        self.authImageBackView.addSubview(authImageBtn)
        authImageBtn.snp.makeConstraints { make in
            make.center.equalTo(authImageBackView)
            make.width.equalTo(authImageBackView)
            make.height.equalTo(authImageBackView)
        }
        authImageBtn.setImage(UIImage(named: "btnPhotoAlbum"), for: .normal)
        authImageBtn.imageView?.contentMode = .scaleAspectFit
        authImageBtn.imageEdgeInsets = UIEdgeInsets(top: self.view.frame.width * 0.2 * 0.2, left: self.view.frame.width * 0.2 * 0.2, bottom: self.view.frame.width * 0.2 * 0.2, right: self.view.frame.width * 0.2 * 0.2)
        
        self.mainScrollView.addSubview(authAudioBackView)
        authAudioBackView.snp.makeConstraints { make in
            make.top.equalTo(self.authImageBackView)
            make.width.equalTo(self.authImageBackView)
            make.height.equalTo(self.authImageBackView)
            make.leading.equalTo(self.authImageBackView.snp.trailing).offset(self.view.frame.width * 0.1)
        }
        authAudioBackView.layer.borderColor = UIColor.lightGray.cgColor
        authAudioBackView.layer.borderWidth = 1
        authAudioBackView.layer.shadowColor = UIColor.black.cgColor
        authAudioBackView.layer.shadowOpacity = 0.7
        authAudioBackView.layer.shadowOffset = CGSize(width: 2, height: 2)
        authAudioBackView.layer.shadowRadius = 5
        authAudioBackView.layer.cornerRadius = 20
        authAudioBackView.backgroundColor = .white
        
        self.authAudioBackView.addSubview(authAudioBtn)
        authAudioBtn.snp.makeConstraints { make in
            make.center.equalTo(authAudioBackView)
            make.width.equalTo(authAudioBackView)
            make.height.equalTo(authAudioBackView)
        }
        authAudioBtn.setImage(UIImage(named: "btnMic"), for: .normal)
        authAudioBtn.imageView?.contentMode = .scaleAspectFit
        authAudioBtn.imageEdgeInsets = UIEdgeInsets(top: self.view.frame.width * 0.2 * 0.2, left: self.view.frame.width * 0.2 * 0.2, bottom: self.view.frame.width * 0.2 * 0.2, right: self.view.frame.width * 0.2 * 0.2)
        
        self.mainScrollView.addSubview(authCheckBackView)
        authCheckBackView.snp.makeConstraints { make in
            make.top.equalTo(self.authImageBackView)
            make.width.equalTo(self.authImageBackView)
            make.height.equalTo(self.authImageBackView)
            make.leading.equalTo(self.authAudioBackView.snp.trailing).offset(self.view.frame.width * 0.1)
        }
        authCheckBackView.layer.borderColor = UIColor.lightGray.cgColor
        authCheckBackView.layer.borderWidth = 1
        authCheckBackView.layer.shadowColor = UIColor.black.cgColor
        authCheckBackView.layer.shadowOpacity = 0.7
        authCheckBackView.layer.shadowOffset = CGSize(width: 2, height: 2)
        authCheckBackView.layer.shadowRadius = 5
        authCheckBackView.layer.cornerRadius = 20
        authCheckBackView.backgroundColor = .white
        
        self.authCheckBackView.addSubview(authCheckBtn)
        authCheckBtn.snp.makeConstraints { make in
            make.center.equalTo(authCheckBackView)
            make.width.equalTo(authCheckBackView)
            make.height.equalTo(authCheckBackView)
        }
        authCheckBtn.setImage(UIImage(named:"btnCheck"), for: .normal)
        authCheckBtn.imageView?.contentMode = .scaleAspectFit
        authCheckBtn.imageEdgeInsets = UIEdgeInsets(top: self.view.frame.width * 0.2 * 0.2, left: self.view.frame.width * 0.2 * 0.2, bottom: self.view.frame.width * 0.2 * 0.2, right: self.view.frame.width * 0.2 * 0.2)
        
        // 인증 방법에 따라서 보여지고 가려지고 해야함
        self.mainScrollView.addSubview(audioPlayArea)
        audioPlayArea.snp.makeConstraints { make in
            make.top.equalTo(self.authCheckBtn.snp.bottom).offset(25)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
        }
        audioPlayArea.backgroundColor = UIColor.blue
        
        // 인증 방법에 따라서 보여지고 가려지고 해야함
        self.mainScrollView.addSubview(authImageView1)
        authImageView1.snp.makeConstraints { make in
            make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.22)
            make.height.equalTo(self.view.frame.width * 0.22)
            make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
        }
        authImageView1.backgroundColor = .lightGrayColor
        
        self.mainScrollView.addSubview(authImageView2)
        authImageView2.snp.makeConstraints { make in
            make.top.equalTo(self.authImageView1)
            make.width.equalTo(self.authImageView1)
            make.height.equalTo(self.authImageView1)
            make.left.equalTo(self.authImageView1.snp.right).offset(self.view.frame.width * 0.02)
        }
        authImageView2.backgroundColor = .lightGrayColor
        
        self.mainScrollView.addSubview(authImageView3)
        authImageView3.snp.makeConstraints { make in
            make.top.equalTo(self.authImageView1)
            make.width.equalTo(self.authImageView1)
            make.height.equalTo(self.authImageView1)
            make.left.equalTo(self.authImageView2.snp.right).offset(self.view.frame.width * 0.02)
        }
        authImageView3.backgroundColor = .lightGrayColor
        
        self.mainScrollView.addSubview(togetherFriendLabel)
        togetherFriendLabel.snp.makeConstraints { make in
            make.top.equalTo(self.authImageView1.snp.bottom).offset(25)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.leading.equalTo(self.authLable)
            make.height.equalTo(self.authLable)
        }
        togetherFriendLabel.adjustsFontSizeToFitWidth = true
        togetherFriendLabel.text = "함께 도전 중인 친구"
        togetherFriendLabel.textAlignment = .left
        togetherFriendLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.mainScrollView.addSubview(togetherExplainLabel)
        togetherExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.togetherFriendLabel.snp.bottom)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.leading.equalTo(self.togetherFriendLabel)
            make.height.equalTo(15)
        }
        togetherExplainLabel.text = "* 친구를 초대 하고 함께 도전을 진행해 보세요!"
        togetherExplainLabel.textAlignment = .left
        togetherExplainLabel.adjustsFontSizeToFitWidth = true
        togetherExplainLabel.font = UIFont.italicSystemFont(ofSize: 15)
        togetherExplainLabel.textColor = .lightGray
        
        self.mainScrollView.addSubview(friendImageView1)
        friendImageView1.snp.makeConstraints { make in
            make.top.equalTo(self.togetherExplainLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view.frame.width * 0.2)
            make.left.equalTo(self.view).offset(self.view.frame.width * 0.2)
        }
        friendImageView1.image = UIImage(named: "personFill")
        friendImageView1.contentMode = .scaleAspectFit
        friendImageView1.layer.borderColor = UIColor.lightGrayColor.cgColor
        friendImageView1.layer.borderWidth = 1.0
        friendImageView1.layer.cornerRadius = self.view.frame.width * 0.2 / 2
        
        self.mainScrollView.addSubview(friendAddBtn1)
        friendAddBtn1.snp.makeConstraints { make in
            make.top.equalTo(self.friendImageView1.snp.bottom).offset(15)
            make.width.equalTo(self.friendImageView1)
            make.height.equalTo(self.friendImageView1)
            make.leading.equalTo(self.friendImageView1)
        }
        friendAddBtn1.setImage(UIImage(named:"btnAdd"), for: .normal)
        friendAddBtn1.backgroundColor = .subLightColor
        friendAddBtn1.layer.cornerRadius = self.view.frame.width * 0.2 / 2
        
        self.mainScrollView.addSubview(friendImageView2)
        friendImageView2.snp.makeConstraints { make in
            make.top.equalTo(friendImageView1)
            make.width.equalTo(friendImageView1)
            make.height.equalTo(friendImageView1)
            make.left.equalTo(friendImageView1.snp.right).offset(self.view.frame.width * 0.2)
        }
        friendImageView2.image = UIImage(named: "personFill")
        friendImageView2.contentMode = .scaleAspectFit
        friendImageView2.layer.borderColor = UIColor.lightGrayColor.cgColor
        friendImageView2.layer.borderWidth = 1.0
        friendImageView2.layer.cornerRadius = self.view.frame.width * 0.2 / 2
        
        self.mainScrollView.addSubview(friendAddBtn2)
        friendAddBtn2.snp.makeConstraints { make in
            make.top.equalTo(friendImageView2.snp.bottom).offset(15)
            make.width.equalTo(friendImageView2)
            make.height.equalTo(friendImageView2)
            make.leading.equalTo(friendImageView2)
        }
        friendAddBtn2.setImage(UIImage(named:"btnAdd"), for: .normal)
        friendAddBtn2.backgroundColor = .subLightColor
        friendAddBtn2.layer.cornerRadius = self.view.frame.width * 0.2 / 2
        
        
        self.mainScrollView.addSubview(todayAuthLabel)
        todayAuthLabel.snp.makeConstraints { make in
            make.top.equalTo(friendAddBtn1.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.height.equalTo(self.togetherFriendLabel)
            make.leading.equalTo(self.togetherFriendLabel)
        }
        todayAuthLabel.text = "오늘 인증 현황"
        todayAuthLabel.textAlignment = .left
        todayAuthLabel.adjustsFontSizeToFitWidth = true
        todayAuthLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // 친구 명 수대로 imageview 가 생겨야하고.. 버튼도 생겨야하고... 인증 현황에 따라서 버튼을 체크 모양으로 변경해야함...
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90.0, height: 170.0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.scrollDirection = .horizontal
        self.todayAuthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.mainScrollView.addSubview(todayAuthCollectionView)
        todayAuthCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.todayAuthLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).multipliedBy(0.9)
            make.height.equalTo(180)
            make.centerX.equalTo(self.view)
        }
        todayAuthCollectionView.delegate = self
        todayAuthCollectionView.dataSource = self
        todayAuthCollectionView.register(UINib(nibName: "TodoListDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodoListDetailCollectionViewCell")
        todayAuthCollectionView.backgroundColor = UIColor.backgroundColor
        todayAuthCollectionView.showsHorizontalScrollIndicator = false
        todayAuthCollectionView.layer.borderColor = UIColor.black.cgColor
        todayAuthCollectionView.layer.borderWidth = 1.0
        
        // 스크롤 작동을 위한 임시 라벨
        self.mainScrollView.addSubview(bottomTestLabel)
        bottomTestLabel.snp.makeConstraints { make in
            make.top.equalTo(self.audioPlayArea).offset(1000)
            make.bottom.equalTo(self.mainScrollView.snp.bottom)
            make.width.equalTo(self.mainScrollView)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
        }
        bottomTestLabel.layer.borderWidth = 1.0
        bottomTestLabel.layer.borderColor = UIColor.black.cgColor
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.startDateView.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.endDateView.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.cycleTimeLabel.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
    }
    
    /// 반복주기 시간 선택
    @objc func circleTimeLabelAction(_ tapGesture: UITapGestureRecognizer) {
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = "circleTime"
        // 선택한 시간을 넘겨줘야함
        
        self.present(bottomVC, animated: true, completion: nil)
        
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

extension TodoListDetailViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    //FIXME: 콜렉션 뷰 UI 작성중
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListDetailCollectionViewCell", for: indexPath) as! TodoListDetailCollectionViewCell
        
        cell.personImageView.contentMode = .scaleAspectFit
        cell.personImageView.layer.borderColor = UIColor.black.cgColor
        cell.personImageView.layer.borderWidth = 1.0
        
        cell.personName.text = "\(indexPath.item)"
        
        return cell
    }
    
    
}

