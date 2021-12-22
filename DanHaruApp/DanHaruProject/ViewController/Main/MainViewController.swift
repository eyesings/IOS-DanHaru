//
//  ViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import UIKit
import Lottie
import SnapKit
import SkeletonView

class MainViewController: UIViewController, UITextFieldDelegate,CustomToolBarDelegate {
    
    var dateLabel = UILabel()
    let calendarAnimation = AnimationView()
    
    let calendarShowHideBtn = UIButton()
    let calendarView = UIView()
    var calendar = CalendarView()
    let todoListTableView = UITableView()
    var cautionView = UIView()
    
    var networkView: NetworkErrorView!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var todoListModel: TodoListViewModel!
    
    var selectedDate: String = ""
    var selectedIdxPath: IndexPath!
    
    // 캘린더 화면 노출 여부
    var calendarShowOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestTodoList),
                                               name: Configs.NotificationName.userLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneSetTodoListModel(_:)),
                                               name: Configs.NotificationName.todoListFetchDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestTodoList),
                                               name: Configs.NotificationName.todoListCreateNew, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadUserInfo),
                                               name: Configs.NotificationName.reloadAfterLogout, object: nil)
        
        self.setUI()
        networkView = NetworkErrorView.shared
        networkView.delegate = self
        
        if let _ = UserDefaults.standard.string(forKey: Configs.UserDefaultsKey.userInputID),
           let _ = UserDefaults.standard.string(forKey: Configs.UserDefaultsKey.userInputPW) {
            self.apiService(withType: .UserLogin)
            todoListTableView.showAnimatedGradientSkeleton()
        }
        
        selectedDate = DateFormatter().korDateString()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let toolBar = self.navigationController?.toolbar as? CustomToolBar {
            toolBar.customDelegate = self
            toolBar.setSelectMenu(.home)
        }
        
        calendarAnimation.animation = .named(calendarShowOn ? "up-arrows" : "down-arrows")
        calendarAnimation.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calendar.setDisplayDate(Date())
    }
    
    func ToolBarSelected(_ button: UIButton) {
        // 바텀 체크...
        if  button.tag == ToolBarBtnTag.myPage.rawValue {
            let myPageSB = RadHelper.getVCFromMyPageSB(withID: RadHelper.isLogin() ? StoryBoardRef.myPageVC : StoryBoardRef.noneLoginMyPageVC)
            self.navigationController?.pushViewController(myPageSB, animated: true)
        }
        
    }
    
    @objc func requestTodoList(_ noti: NSNotification) {
        guard let isSuccess = noti.object as? Bool else { return }
        // FIXME: isSuccess 이면 splashImg Dismiss
        if isSuccess { self.apiService(withType: .TodoList) }
    }
    
    @objc func doneSetTodoListModel(_ noti: NSNotification) {
        self.todoListTableView.reloadData()
        self.todoListTableView.hideSkeleton()
        
        if let isSuccess = noti.object as? Bool {
            self.showNoneListView(isSuccess)
        }
        
        guard let rootVC = RadHelper.getRootViewController() else { return }
        rootVC.hideLoadingView()
        
    }
    
    @objc func reloadUserInfo() {
        self.todoListModel = nil
        self.todoListTableView.reloadData()
    }
}


extension MainViewController: NetworkErrorViewDelegate {
    func isNeedRetryService(_ type: APIType) {
        self.apiService(withType: type)
    }
    
    func apiService(withType type: APIType) {
        
        func showNetworkErrView(type: APIType) {
            self.networkView.showNetworkView()
            self.networkView.needRetryType = type
        }
        
        if type == .UserLogin
        {
            _ = UserInfoViewModel.init(UserDefaults.userInputId, UserDefaults.userInputPw) { showNetworkErrView(type: $0) }
        }
        else if type == .TodoList
        {
            todoListModel = TodoListViewModel.init(searchDate: selectedDate) { showNetworkErrView(type: $0) }
            todoListTableView.reloadData()
        }
        else if type == .TodoDetail {
            guard let todoModelID = self.todoListModel.model[self.selectedIdxPath.row].todo_id else { return }
            
            let detailVC = TodoListDetailViewController()
            detailVC.modalPresentationStyle = .fullScreen
            /*
            let _ = TodoDetailViewModel(1, "2021-12-08") { model in
                detailVC.detailInfoModel = model
                
                if let list = model.certification_list {
                    self.getCertificateImage(list) { images in
                        // 인증 이미지가 있으면
                        detailVC.selectedImage = images
                        DispatchQueue.main.async {
                            if images.count > 0 { detailVC.isRegisterAuth = true }
                            self.navigationController?.pushViewController(detailVC)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailVC)
                    }
                }
                
            } errHandler: { showNetworkErrView(type: $0) }
            */
            
            let _ = TodoDetailViewModel(todoModelID, selectedDate) { model in
                detailVC.detailInfoModel = model
                self.navigationController?.pushViewController(detailVC)
            } errHandler: { showNetworkErrView(type: $0) }
            
        }
    }
    
    //FIXME: 인증 이미지 불러오는 함수 수정중
    func getCertificateImage(_ list: [ChallengeCertiModel], handler: @escaping(_ dic: [UIImage]) -> Void) {
        
        var certiImages: [UIImage] = []
        
        for i in 0 ..< list.count {
            
            // 로그인한 계정 == 인증 리스트에서 자신의 인증만 찾기
            //if UserModel.mem_id == list[i].mem_id {
            if "test3" == list[i].mem_id {
                
                if let certiImageString = list[i].certi_img {
                    
                    let certiStrArr = certiImageString.components(separatedBy: ",")
                    for q in 0 ..< certiStrArr.count {
                        
                        RadServerNetwork.getFromServerNeedAuth(url: Configs.API.getCertiImg + "/\(certiStrArr[q])") { dic in
                            if let certiImage = dic?["image"] {
                        
                                certiImages.append(certiImage as! UIImage)
                                
                                if q + 1 == certiStrArr.count {
                                    handler(certiImages)
                                }
                                
                            }
                            
                        } errorHandler: { error in
                            print("image called failed")
                        }
                        
                        
                    }
                    
                    
                } else {
                    handler(certiImages)
                }
                
        
            }
        }
        
    }
    
    
}
