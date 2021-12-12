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
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        initLayout()
    }
    
    @IBAction func onTapAskBtn(_ sender: UIButton) {
        
        if let askVC = RadHelper.getVCFromMyPageSB(withID: StoryBoardRef.askVC) as? AskViewController {
            self.navigationController?.pushViewController(askVC)
        }
    }
    
    @IBAction func onTapUpdateBtn(_ sender: UIButton) {
        print("open appstore! if need Update")
    }
    
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func onTapLogout(_ sender: UIButton) {
        RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title, message: RadMessage.Setting.logoutMsg, isNeedCancel: true, viewController: self) { isCheck in
            if isCheck {
                UserDefaults.standard.saveUserInputVal(id: RadHelper.tempraryID, pw: "1")
                UserModel = UserInfoModel()
                
                RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                                message: RadMessage.Setting.returnToLogin,
                                                                isNeedCancel: true,
                                                                viewController: self) { isCheck in
                    if isCheck {
                        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                            appdelegate.switchToHome(needMovePageRef: StoryBoardRef.loginVC)
                        }
                    } else {
                        NotificationCenter.default.post(name: Configs.NotificationName.reloadAfterLogout, object: nil)
                        self.navigationController?.popToMainViewController()
                    }
                }
                
            }
            
        }
    }
    
    @IBAction func onTapUserDel(_ sender: UIButton) {
        RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title, message: RadMessage.Setting.accountDelMsg, isNeedCancel: true, viewController: self) { isCheck in
            if isCheck {
                print("move to main? and remove user info")
                UserDefaults.standard.rmUserInputVal()
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
        for view in userSettingMenuList {
            view.isHidden = !RadHelper.isLogin()
        }
    }
}
