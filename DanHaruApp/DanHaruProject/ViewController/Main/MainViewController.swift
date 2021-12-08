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
    var todoAddBtn = UIButton()
    let calendarView = UIView()
    var calendar = CalendarView()
    let todoListTableView = UITableView()
    var cautionView = UIView()
    
    var todoListModel: TodoListViewModel!
    var todoListCellBackGroundColor: [UIColor] = [
        UIColor.todoLightBlueColor,
        UIColor.todoLightGreenColor,
        UIColor.todoLightYellowColor,
        UIColor.todoHotPickColor
    ]
    
    var selectedDate: String = ""
    
    // 캘린더 화면 노출 여부
    var calendarShowOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestTodoList(_:)),
                                               name: Configs.NotificationName.userLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneSetTodoListModel(_:)),
                                               name: Configs.NotificationName.todoListFetchDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestTodoList),
                                               name: Configs.NotificationName.todoListCreateNew, object: nil)
        
        self.setUI()
        
        if let _ = UserDefaults.standard.string(forKey: Configs.UserDefaultsKey.userInputID),
           let _ = UserDefaults.standard.string(forKey: Configs.UserDefaultsKey.userInputPW) {
            UserModel = UserInfoViewModel(UserDefaults.userInputId, UserDefaults.userInputPw).model
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
        if isSuccess { todoListModel = TodoListViewModel.init(searchDate: selectedDate) }
        else { RadHelper.getRootViewController()?.showNetworkErrorView() }
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
    
}


