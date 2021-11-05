//
//  BottomSheetsViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/28.
//

import UIKit
import SnapKit

class BottomSheetsViewController: UIViewController, UITextFieldDelegate {
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
        
        if self.checkShowUI == "" {
            setLayout()
        } else if checkShowUI == "startDate" || checkShowUI == "endDate" {
            setDateLayout()
        } else if checkShowUI == "circleTime" {
            setCirCleTimeLayout()
        }
        
    }
    
    func setCirCleTimeLayout() {
        
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(10)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(25)
        }
        bottomTitle.text = "반복주기 시간 선택"
        bottomTitle.textAlignment = .center
        bottomTitle.textColor = .black
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 25)
        bottomTitle.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView).offset(30)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.38)
        }
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(self.view.frame.height / 2 - self.view.frame.height * 0.38 - 60)
            make.width.equalTo(self.bottomSheetView)
            make.centerX.equalTo(self.bottomSheetView)
            //make.height.equalTo(self.view.frame.height / 2 - self.view.frame.height * 0.38 - 10)
            make.height.equalTo(60)
            //make.bottom.equalTo(self.bottomSheetView)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("확인", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoCheckTime(_:)), for: .touchUpInside)
    }
    
    @objc func bottomTodoCheckTime(_ sender: UIButton) {
        //print("시간 \(self.datePicker.date)")
        Configs.formatter.dateFormat = "HH:mm"
        let changeTime = Configs.formatter.string(from: self.datePicker.date)
        
        print("봅시다 \(changeTime)")
        
        
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
        
        if self.checkShowUI == "startDate" {
            vc.startDateLabel.text = changeDate
        } else if self.checkShowUI == "endDate" {
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
        
        let preVc = self.presentingViewController
        guard let vc = preVc as? MainViewController else { return }
        
        let addData = MainViewController.dummyModel(title: titleText, date: startDate)
        
        vc.tableData.append(addData)
        
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
