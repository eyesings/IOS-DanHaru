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
    
    private var isDrawing: Bool = false
    var networkErrView: NetworkErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageLayoutInit()
        
        networkErrView = NetworkErrorView.shared
        networkErrView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: screenwidth, height: screenheight + 20)
        scrollTopViewHeightConst.constant = screenheight
        
        if isDrawing == false { pieChartViewInit() }
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
        self.isDrawing = true
        self.showLoadingView()
        _ = UserTodoCntViewModel.init { todoCntModel in
            
            self.drawPieChartView(CGFloat(todoCntModel.todo_complete_count ?? 0),
                                  totalCnt: CGFloat(todoCntModel.todo_total_count ?? 0),
                                  self.toDoScoreView,
                                  dataType: .todo)
            
            self.drawPieChartView(CGFloat(todoCntModel.challenge_complete_count ?? 0),
                                  totalCnt: CGFloat(todoCntModel.challenge_total_count ?? 0),
                                  self.challengeScoreView,
                                  dataType: .challenge)
            
            let totalCompleteCnt = (todoCntModel.todo_complete_count ?? 0) + (todoCntModel.challenge_complete_count ?? 0)
            let totalTotalCnt = (todoCntModel.todo_total_count ?? 0) + (todoCntModel.challenge_total_count ?? 0)
            self.drawPieChartView(CGFloat(totalCompleteCnt),
                                  totalCnt: CGFloat(totalTotalCnt),
                                  self.totalScoreView,
                                  dataType: .done)
            
            self.hideLoadingView()
        } errHandler: { apitype in
            self.networkErrView.needRetryType = apitype
            self.networkErrView.showNetworkView()
            self.hideLoadingView()
        }
    }
    
    private func drawPieChartView(_ doneCnt: CGFloat, totalCnt: CGFloat, _ onView: UIView, dataType: UserTodoType) {
        
        DispatchQueue.main.async {
            if let pieChart = onView.subviews.first {
                pieChart.removeFromSuperview()
            }
            
            if totalCnt == 0 {
                let label = UILabel.init(frame: .zero)
                switch dataType {
                case .todo:
                    label.text = "아직 등록된 할 일 이 없어요."
                case .challenge:
                    label.text = "아직 친구와 함께하는 도전이 없어요."
                case .done:
                    label.text = "아직 완료된 할 일, 도전이 없어요."
                }
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
            } else {
                pieChartView.slices = [Slice(percent: 1 - pieChartVal, color: .subHeavyColor),
                                       Slice(percent: pieChartVal, color: .subLightColor)]
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

// MARK: - NetworkErrDelegate
extension MyPageViewController: NetworkErrorViewDelegate {
    func isNeedRetryService(_ type: APIType) {
        if type == .UserTodoCnt { self.pieChartViewInit() }
    }
}
