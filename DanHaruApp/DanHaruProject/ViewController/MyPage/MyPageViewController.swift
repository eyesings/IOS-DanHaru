//
//  MyPageViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation
import UIKit


class MyPageViewController: UIViewController {
    
    @IBOutlet var scrollTopViewHeightConst: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var profileUserName: UILabel!
    @IBOutlet var profileUserIntroduce: UILabel!
    
    @IBOutlet var userScoreView: UIView!
    @IBOutlet var toDoScoreView: UIView!
    @IBOutlet var challengeScoreView: UIView!
    @IBOutlet var totalScoreView: UIView!
    
    @IBOutlet var snapShotUnderView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageLayoutInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isMovingFromParent { self.updateProfile() }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: screenwidth, height: screenheight + 20)
        scrollTopViewHeightConst.constant = screenheight
        
        pieChartViewInit()
    }
    
    
    // MARK: - OBJC Method
    @IBAction func onTapMoveToProfileEdit(_ sender: UIButton) {
        if let profileEditVC = RadHelper.getVCFromMyPageSB(withID: StoryBoardRef.profileVC) as? ProfileEditViewController {
            profileEditVC.selectedImage = self.profileImgView.image
            self.navigationController?.pushViewController(profileEditVC)
        }
    }
    
    @IBAction func onTapSaveProfileBtn(_ sender: UIButton) {
        let absolutePosition = snapShotUnderView.convert(snapShotUnderView.bounds, to: nil)
        if let image = self.view.takeScreenShot(absolutePosition.maxY - snapShotUnderView.frame.height) {
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
        }
        
    }
    
    
    @IBAction func onTapMoveToChallenge(_ sender: UIButton) {
        if let challangeVC = RadHelper.getVCFromMyPageSB(withID: StoryBoardRef.myChallangeVC) as? MyChallengeListViewController {
            
            self.navigationController?.pushViewController(challangeVC)
        }
    }
    
    @IBAction func onTapMoveToSetting(_ sender: UIButton) {
        if let settingVC = RadHelper.getVCFromMyPageSB(withID: StoryBoardRef.settingVC) as? SettingViewController {
            
            self.navigationController?.pushViewController(settingVC)
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)  {
        
        func showToasPopup(_ str: String) {
            DispatchQueue.main.async {
                let warning = WarningView.shared
                warning.message = str
                warning.showAndAutoHide()
            }
        }
        
        print("error : \(String(describing: error))")
        showToasPopup(error == nil ? RadMessage.MyPage.savePhotoSuccess : RadMessage.MyPage.savePhotoFail)
    }
    
}

// MARK: - CustomToolBarDelegate
extension MyPageViewController: CustomToolBarDelegate {
    func ToolBarSelected(_ button: UIButton) {
        if button.tag == ToolBarBtnTag.home.rawValue {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UIView Init
extension MyPageViewController {
    
    public func updateProfile() {
        RadHelper.getProfileImage { img in
            let img = img
            DispatchQueue.main.async {
                self.profileImgView.image = img
            }
        }
        profileUserName.text = UserModel.profileName ?? UserModel.memberId
        profileUserIntroduce.text = UserModel.profileIntroStr
    }
    
    private func pageLayoutInit() {
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        profileImgView.backgroundColor = .clear
        RadHelper.getProfileImage { img in
            DispatchQueue.main.async {
                self.profileImgView.image = img
            }
        }
        profileUserName.text = UserModel.profileName ?? UserModel.memberId
        profileUserIntroduce.text = UserModel.profileIntroStr
        
        userScoreViewLayerInit()
        
        if let toolBar = self.navigationController?.toolbar as? CustomToolBar {
            toolBar.customDelegate = self
            toolBar.setSelectMenu(.myPage)
        }
    }
    
    private func userScoreViewLayerInit() {
        userScoreView.layer.cornerRadius = 15
        
        userScoreView.createShadow(CGSize(width: 0, height: 10))
        
        userScoreView.layer.masksToBounds = false
    }
    
    private func pieChartViewInit() {
        
        _ = UserTodoCntViewModel.init { todoCntModel in
            
            self.drawPieChartView(CGFloat(todoCntModel.todo_complete_count ?? 0),
                                  totalCnt: CGFloat(todoCntModel.todo_total_count ?? 0),
                                  self.toDoScoreView)
            
            self.drawPieChartView(CGFloat(todoCntModel.challenge_complete_count ?? 0),
                                  totalCnt: CGFloat(todoCntModel.challenge_total_count ?? 0),
                                  self.challengeScoreView,
                                  isChallenge: true)
            
            let totalCompleteCnt = (todoCntModel.todo_complete_count ?? 0) + (todoCntModel.challenge_complete_count ?? 0)
            let totalTotalCnt = (todoCntModel.todo_total_count ?? 0) + (todoCntModel.challenge_total_count ?? 0)
            self.drawPieChartView(CGFloat(totalCompleteCnt),
                                  totalCnt: CGFloat(totalTotalCnt),
                                  self.totalScoreView)
            
        } errHandler: { apitype in
            print("apiType \(apitype)")
            self.drawPieChartView(0, totalCnt: 0, self.challengeScoreView)
        }
    }
    
    private func drawPieChartView(_ doneCnt: CGFloat, totalCnt: CGFloat, _ onView: UIView, isChallenge: Bool = false) {
        
        DispatchQueue.main.async {
            if let pieChart = onView.subviews.first {
                pieChart.removeFromSuperview()
            }
            
            if totalCnt == 0 && isChallenge {
                let label = UILabel.init(frame: .zero)
                label.text = "아직 친구와 함께하는 도전이 없어요."
                label.font = .systemFont(ofSize: 13.0)
                label.textAlignment = .center
                label.center = onView.center
                label.numberOfLines = 0
                onView.addSubview(label)
                
                label.snp.makeConstraints { make in
                    make.centerX.centerY.equalTo(onView)
                    make.width.height.equalTo(onView).multipliedBy(0.8)
                }
                return
            }
            
            let pieChartView = PieChartView(frame: CGRect(origin: .zero, size: onView.frame.size))
            let pieChartVal = doneCnt / totalCnt
            
            if pieChartVal > 1.0 || pieChartVal == 0.0 {
                pieChartView.slices = [Slice(percent: 0.9999, color: .subLightColor)]
            } else if pieChartVal == 1.0 {
                pieChartView.slices = [Slice(percent: 0.9999, color: .subHeavyColor)]
            } else if pieChartVal == 0.0 {
                pieChartView.slices = [Slice(percent: pieChartVal, color: .subHeavyColor),
                                       Slice(percent: 1 - pieChartVal, color: .subLightColor)]
            }
            
            onView.addSubview(pieChartView)
            pieChartView.animateChart()
            
            let label = UILabel()
            label.text = "\(Int(doneCnt))/\(Int(totalCnt))"
            label.textColor = .customBlackColor
            label.font = .systemFont(ofSize: 15.0)
            pieChartView.addSubview(label)
            
            label.snp.makeConstraints { label in
                label.centerX.centerY.equalTo(pieChartView)
            }
        }
    }
}
