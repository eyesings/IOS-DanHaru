//
//  MyPageVC+OBJC.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/10.
//

import Foundation
import UIKit

// MARK: - OBJC Method
extension MyPageViewController {
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
