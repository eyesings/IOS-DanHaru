//
//  TodoListDetailViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/29.
//

import UIKit
import SnapKit
import Lottie

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
    
    var titleText : String = "";
    
    var currentIdx: CGFloat = 0.0
    
    // 위클리 데이트 프로그래스 바 색깔
    var todoListCellBackGroundColor: [UIColor] = [
        UIColor.todoLightBlueColor,
        UIColor.todoLightGreenColor,
        UIColor.todoLightYellowColor,
        UIColor.todoHotPickColor
    ]
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.titleTextField.makesToCustomField()
        self.startDateView.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.endDateView.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
        self.cycleTimeLabel.layer.addBorder([.top,.bottom], color: .lightGrayColor, width: 0.8)
    }
    
    /// 반복주기 시간 선택
    @objc func circleTimeLabelAction(_ tapGesture: UITapGestureRecognizer) {
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.cycleTime.rawValue
        // 선택한 시간을 넘겨줘야함
        
        self.present(bottomVC, animated: true, completion: nil)
        
    }
    
    /// 오디오 버튼 클릭
    @objc func audioAuth(_ sender:UIButton) {
        
        let bottomVC = BottomSheetsViewController()
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.checkShowUI = BottomViewCheck.audioRecode.rawValue
        
        self.present(bottomVC, animated: true, completion: nil)
    }
    
    // 이미지 버튼 클릭
    @objc func photoAlbumAuth(_ sender: UIButton) {
        
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        if newImage != nil {
            
            if authImageView1.image == nil {
                // 이미지 뷰가 보여야함
                self.authImageView1.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(self.view).offset(self.view.frame.width * 0.15)
                }
                
                self.imageDeleteBtn1.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView1).offset(-5)
                    make.width.equalTo(authImageView1).multipliedBy(0.3)
                    make.height.equalTo(authImageView1).multipliedBy(0.3)
                    make.trailing.equalTo(authImageView1).offset(5)
                }
                
                
                self.authImageView1.image = newImage
                
            } else if authImageView2.image == nil {
                
                authImageView2.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(authImageView1.snp.right).offset(self.view.frame.width * 0.02)
                }
                
                self.imageDeleteBtn2.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView2).offset(-5)
                    make.width.equalTo(authImageView2).multipliedBy(0.3)
                    make.height.equalTo(authImageView2).multipliedBy(0.3)
                    make.trailing.equalTo(authImageView2).offset(5)
                }
                
                self.authImageView2.image = newImage
                
            } else if authImageView3.image == nil {
                
                authImageView3.snp.remakeConstraints { make in
                    make.top.equalTo(self.audioPlayArea.snp.bottom).offset(20)
                    make.width.equalTo(self.view).multipliedBy(0.22)
                    make.height.equalTo(self.view.frame.width * 0.22)
                    make.left.equalTo(authImageView2.snp.right).offset(self.view.frame.width * 0.02)
                }
                
                self.imageDeleteBtn3.snp.remakeConstraints { make in
                    make.top.equalTo(authImageView3).offset(-5)
                    make.width.equalTo(authImageView3).multipliedBy(0.3)
                    make.height.equalTo(authImageView3).multipliedBy(0.3)
                    make.trailing.equalTo(authImageView3).offset(5)
                }
                
                self.authImageView3.image = newImage
                
            } else {
                
                RadAlertViewController.alertControllerShow(WithTitle: "알림", message: "인증 사진은 최대 3개까지 가능합니다.", isNeedCancel: false, viewController: self)
                
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    // FIXME: - 이미지 삭제 후 UI 변경 작업 필요
    @objc func deleteAuthImage(_ sender: UIButton) {
        
        if sender.tag == ImageDeleteBtnTag.deleteImageView1.rawValue {
            
            self.authImageView1.image = nil
            
        } else if sender.tag == ImageDeleteBtnTag.deleteImageView2.rawValue {
            
            self.authImageView2.image = nil
            
        } else if sender.tag == ImageDeleteBtnTag.deleteImageView3.rawValue {
            
            self.authImageView3.image = nil
            
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



