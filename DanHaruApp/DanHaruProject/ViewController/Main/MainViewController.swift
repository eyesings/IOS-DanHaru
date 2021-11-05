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

    let calendarAnimation = AnimationView(name:"down-arrows")
    
    let calendarShowHideBtn = UIButton()
    var addBtn = UIButton()
    let calendarView = UIView()
    let todoListTableView = UITableView()
    
    // 바텀 시트
    let bottomTitle = UILabel()
    let cancelBtn = UIButton()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let startDateLabel = UILabel()
    let datePicker = UIDatePicker()
    let bottomTodoAddBtn = UIButton()
    
    //var dummyData = ["테스트1","테스트2","테스트3","테스트4","테스트5","테스트6","테스트7","테스트8","테스트9"]
    
    struct dummyModel {
        var title: String?
        var date: Date?
    }
    
    var dummyData : [dummyModel] = [
        dummyModel(title: "테스트1", date: Date()),
        dummyModel(title: "테스트2", date: Date()),
        dummyModel(title: "테스트3", date: Date()),
        dummyModel(title: "테스트4", date: Date()),
        dummyModel(title: "테스트5", date: Date()),
        dummyModel(title: "테스트6", date: Date()),
        dummyModel(title: "테스트7", date: Date()),
        dummyModel(title: "테스트8", date: Date()),
        dummyModel(title: "테스트9", date: Date()),
        dummyModel(title: "테스트10", date: Date()),
    ]
    
    
    var tableData: [dummyModel] = []
    
    var todoListCellBackGroundColor: [UIColor] = [
        UIColor.todoLightBlueColor,
        UIColor.todoLightGreenColor,
        UIColor.todoLightYellowColor,
        UIColor.todoHotPickColor
    ]
    
    //lazy var bottomVC = BottomSheetViewController(contentViewController: bottomSheetViewController)
    // 캘린더 화면 노출 여부
    var calendarShowOn = false
    
    let bottomSheetViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .backgroundColor
        
        self.setUI()
        todoListTableView.showSkeleton()
        
        // 데이터 삽입
        self.tableData = self.dummyData
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let toolBar = self.navigationController?.toolbar as? CustomToolBar {
            toolBar.customDelegate = self
            toolBar.setSelectMenu(.home)
        }
        
        if self.calendarShowOn {
            self.calendarAnimation.animation = .named("up-arrows")
            self.calendarAnimation.play()
        } else {
            self.calendarAnimation.animation = .named("down-arrows")
            self.calendarAnimation.play()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.todoListTableView.reloadData()
            self.todoListTableView.hideSkeleton()
        }
    }

    
    func ToolBarSelected(_ button: UIButton) {
        // 바텀 체크...
        if  button.tag == ToolBarBtnTag.myPage.rawValue {
            
            let myPageSB = RadHelper.getVCFromMyPageSB(withID: StoryBoardRef.myPageVC)
            
            self.navigationController?.pushViewController(myPageSB, animated: true)
        }
        
    }
    
}


