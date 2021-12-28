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
    
    var todoListModel: TodoListViewModel!
    
    var selectedDate: String = ""
    var selectedIdxPath: IndexPath!
    var invitedTodoIdx: Int?
    var openDetailTotoIdx: Int?
    var invitedFriendId: String?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.inviteChallFromFriend(_:)),
                                               name: Configs.NotificationName.inviteFriendChall, object: nil)
        
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
        if isSuccess {
            splashViewRemove()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.apiService(withType: .TodoList)
            }
        }
    }
    
    @objc func doneSetTodoListModel(_ noti: NSNotification) {
        self.todoListTableView.reloadData()
        self.todoListTableView.hideSkeleton()
        
        if let isSuccess = noti.object as? Bool {
            self.showNoneListView(isSuccess)
        }
        
        guard let rootVC = RadHelper.getRootViewController() else { return }
        rootVC.hideLoadingView()
        
        if let _ = self.openDetailTotoIdx {
            self.apiService(withType: .TodoDetail)
            self.openDetailTotoIdx = nil
        }
        
        print("default \(UserDefaults.notiScheduledData)")
    }
    
    @objc func reloadUserInfo() {
        self.todoListModel = nil
        self.todoListTableView.reloadData()
        let tempID = RadHelper.tempraryID
        _ = UserJoinViewModel.init("\(tempID)@danharu.com", tempID, "1", errHandler: { print("error Occur \($0)") })
    }
    
    @objc
    func splashViewRemove() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0) {
                self.appDelegate.splashView.alpha = 0.0
            } completion: { _ in
                self.appDelegate.splashView.removeFromSuperview()
            }
        }
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
            var todoModelId: Int!
            
            if let selectIdx = self.selectedIdxPath,
               let todoIdxFromIndexPath = self.todoListModel.model[selectIdx.row].todo_id {
                todoModelId = todoIdxFromIndexPath
            } else if let todoIdxFromInvite = self.invitedTodoIdx {
                todoModelId = todoIdxFromInvite
            } else if let todoIdxFormNoti = self.openDetailTotoIdx {
                todoModelId = todoIdxFormNoti
            } else {
                Dprint("model get Error")
                return
            }
            
            let detailVC = TodoListDetailViewController()
            detailVC.modalPresentationStyle = .fullScreen
            
            func presentDetailVC() {
                self.navigationController?.pushViewController(detailVC)
                self.invitedFriendId = nil
                self.invitedTodoIdx = nil
            }
            
            if let _ = self.invitedFriendId {
                detailVC.invitedMemId = self.invitedFriendId
                detailVC.isForInviteFriend = true
            }
            
            let _ = TodoDetailViewModel(todoModelId, selectedDate) { model in
                detailVC.detailInfoModel = model
    
                if let list = model.certification_list {
                    if list.count > 0 {
                        self.getCertificateImage(list) { images in
                            // 인증 이미지가 있으면
                            detailVC.selectedImage = images
                            DispatchQueue.main.async {
                                if images.count > 0 { detailVC.isRegisterAuth = true }
                                presentDetailVC()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            presentDetailVC()
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        presentDetailVC()
                    }
                }
                
            } errHandler: { showNetworkErrView(type: $0) }
            
        }
    }
    
    //FIXME: 인증 이미지 불러오는 함수 수정중
    func getCertificateImage(_ list: [ChallengeCertiModel], handler: @escaping(_ dic: [UIImage]) -> Void) {
        
        var certiImages: [UIImage] = []
        
        for i in 0 ..< list.count {
            
            // 로그인한 계정 == 인증 리스트에서 자신의 인증만 찾기
            if UserModel.memberId == list[i].mem_id {
                
                if let certiImageString = list[i].certi_img {
                    
                    let certiStrArr = certiImageString.components(separatedBy: ",")
                    for q in 0 ..< certiStrArr.count {
                        
                        RadServerNetwork.getFromServerNeedAuth(url: Configs.API.getCertiImg + "/\(certiStrArr[q].trimmingCharacters(in: .whitespacesAndNewlines))") { dic in
                            if let certiImage = dic?["image"] {
                                certiImages.append(certiImage as! UIImage)
                                
                                if q + 1 == certiStrArr.count {
                                    if certiImages.count != q + 1 { // 이미지 불러오기 딜레이 되는 경우
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            handler(certiImages)
                                        }
                                    } else {
                                        handler(certiImages)
                                    }
                                    
                                }
                                
                            }
                            
                        } errorHandler: { error in
                            print("image called failed")
                        }
                        
                        
                    }
                    
                    
                } else {
                    if i + 1 == list.count {
                        handler(certiImages)
                    } else {
                        continue
                    }
                }
                
        
            } else {
                if i + 1 == list.count {
                    handler(certiImages)
                } else {
                    continue
                }
                
            }
            
        }
        
    }
    
    
}
