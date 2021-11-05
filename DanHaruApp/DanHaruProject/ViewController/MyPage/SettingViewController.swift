//
//  SettingViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/03.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var userSettingMenuList: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
    
    @IBAction func onTapUpdateBtn(_ sender: UIButton) {
        print("open appstore! if need Update")
    }
    
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func onTapLogout(_ sender: UIButton) {
        RadAlertViewController.basicAlertControllerShow(WithTitle: "", message: "로그아웃하시겠습니까?", isNeedCancel: true, viewController: self) { isCheck in
            if isCheck {
                self.navigationController?.popToMainViewController()
            }
        }
    }
    
    @IBAction func onTapUserDel(_ sender: UIButton) {
        RadAlertViewController.basicAlertControllerShow(WithTitle: "", message: "회원 정보를 삭제하시겠습니까?", isNeedCancel: true, viewController: self) { isCheck in
            if isCheck {
                print("move to main? and remove user info")
            }
        }
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController()
        }
    }
    
}


extension SettingViewController {
    private func initLayout() {
        updateBtn.layer.cornerRadius = updateBtn.frame.height / 2
        
        // MARK: update 불필요 할때
//        updateBtn.backgroundColor = .lightGrayColor
//        updateBtn.setTitleColor(.heavyGrayColor, for: .normal)
//        updateBtn.isEnabled = false

        // MARK: 로그인 상태가 아닐 때
        if !RadHelper.isLogin {
            for view in userSettingMenuList {
                view.isHidden = true
            }
        }
    }
}
