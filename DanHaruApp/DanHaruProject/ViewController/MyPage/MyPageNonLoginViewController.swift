//
//  MyPageNonLoginViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/03.
//

import Foundation
import UIKit


class MyPageNonLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let customToolBar = self.navigationController?.toolbar as? CustomToolBar {
            customToolBar.customDelegate = self
            customToolBar.setSelectMenu(.myPage)
        }
    }
    
    @IBAction func onTapMoveToLogin(_ sender: UIButton) {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.switchToHome(needMovePageRef: StoryBoardRef.loginVC)
        }
    }
    
    @IBAction func onTapMoveSetting(_ sender: UIButton) {
        if let settingVC = RadHelper.getVCFromMyPageSB(withID: StoryBoardRef.settingVC) as? SettingViewController {
            
            self.navigationController?.pushViewController(settingVC)
        }
    }
}


extension MyPageNonLoginViewController: CustomToolBarDelegate {
    func ToolBarSelected(_ button: UIButton) {
        if button.tag == ToolBarBtnTag.home.rawValue {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
