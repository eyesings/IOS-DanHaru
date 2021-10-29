//
//  BottomSheetsViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/28.
//

import UIKit

class BottomSheetsViewController: UIViewController, UITextFieldDelegate {
    /// 화면 딤 처리 부분
    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        return view
    }()
    /// UI 가 작성되는 뷰
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    var defaultHeight: CGFloat = 0.0
    
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
        
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
        
    }
    
    private func setupUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)

        dimmedView.alpha = 0.0
        
        setupLayout()
    }
    
    func setupLayout() {
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
        
        self.bottomSheetView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView)
            make.centerX.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.5)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.1)
        }
        bottomTitle.text = "일정 등록"
        bottomTitle.textAlignment = .center
        bottomTitle.adjustsFontSizeToFitWidth = true
        bottomTitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.bottomSheetView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.bottomSheetView)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.2)
            make.height.equalTo(bottomTitle)
            make.leading.equalTo(bottomTitle.snp.trailing).offset(self.bottomSheetView.frame.width * 0.05)
        }
        cancelBtn.setTitle("X", for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        //cancelBtn.addTarget(self, action: #selector(bottomSheetDismiss(_:)), for: .touchUpInside)
        
        self.bottomSheetView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomTitle.snp.bottom)
            make.width.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.05)
            make.leading.equalTo(self.bottomSheetView).offset(30)
        }
        titleLabel.text = "목표 설정"
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        
        self.bottomSheetView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
        }
        titleTextField.placeholder = "할 일을 등록해 주세요."
        titleTextField.textColor = UIColor.black
        titleTextField.delegate = self
        
        self.bottomSheetView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        startDateLabel.text = "목표 일자 설정"
        startDateLabel.textAlignment = .left
        startDateLabel.adjustsFontSizeToFitWidth = true
        startDateLabel.textColor = UIColor.black
        
        self.bottomSheetView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.bottomSheetView).multipliedBy(0.18)
            make.width.equalTo(self.bottomSheetView).multipliedBy(0.8)
            make.top.equalTo(self.startDateLabel.snp.bottom)
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
            
        // datepicker 가 14로 넘어오면서 많이 변해서 분기처리
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //self.bottomSheetViewController.view.frame.height / 2 - self.bottomSheetViewController.view.frame.height * 0.27 - 20
        
        self.bottomSheetView.addSubview(bottomTodoAddBtn)
        bottomTodoAddBtn.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.width.equalTo(self.bottomSheetView)
            make.centerX.equalTo(self.bottomSheetView)
            make.height.equalTo(self.view.frame.height / 2 - self.view.frame.height * 0.43 + 10)
        }
        bottomTodoAddBtn.backgroundColor = UIColor.darkGray
        bottomTodoAddBtn.setTitle("등록 하기", for: .normal)
        bottomTodoAddBtn.setTitleColor(.white, for: .normal)
        bottomTodoAddBtn.addTarget(self, action: #selector(bottomTodoAddAction(_:)), for: .touchUpInside)
        
        
    }
    
    private func showBottomSheet() {
        
        let safeAreaHeight:CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding:CGFloat = view.safeAreaInsets.bottom
        
        let constant = (safeAreaHeight + bottomPadding) - self.defaultHeight
        self.bottomSheetView.snp.remakeConstraints { make in
            make.top.equalTo(self.view).offset(constant)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: constant)
            self.view.layoutIfNeeded()
            
        } completion: { (_) in
            
        }
    }
    
    private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha:CGFloat = 0.7
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2
        
        let noDimPosition = safeAreaHeight + bottomPadding
        
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * ( 1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
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
    
    func hideBottomSheetAndGoBack() {
        //let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        //let bottomPadding = view.safeAreaInsets.bottom
        //bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func bottomTodoAddAction(_ sender: UIButton) {
        
        let titleText = self.titleTextField.text
        let startDate = self.datePicker.date
        
        print("날짜 \(startDate)")
        
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
