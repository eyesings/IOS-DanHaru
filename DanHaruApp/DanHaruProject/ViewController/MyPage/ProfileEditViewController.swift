//
//  ProfileEditViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/02.
//

import Foundation
import UIKit

class ProfileEditViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileImgSelectBtn: UIButton!
    
    @IBOutlet var nickNameField: UITextField!
    @IBOutlet var introduceField: UITextField!
    
    @IBOutlet var startBtnBottomConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageLayoutInit()
        
        self.registerKeyboardNotification()
    }
    
    private func config() -> FMPhotoPickerConfig {
        var config = FMPhotoPickerConfig()
        
        config.selectMode = .single
        config.maxImage = 1
        
        return config
    }
    
    // MARK: - OBJC Method
    @IBAction func onTapMoveBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func onTapImageSelectBtn(_ sender: UIButton) {
        let vc = FMPhotoPickerViewController(config: config())
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.photoEditorDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTapSaveBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
        // FIXME: user nickname and introduce send to server
        RadHelper.getRootViewController { vc in
            if let rootVc = vc
            {
                RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                                message: RadMessage.ProfileEdit.saveProfile,
                                                                isNeedCancel: false,
                                                                viewController: rootVc)
            }
        }
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController()
        }
    }
    
    @IBAction func onTapScreenGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: UITextField Delegate
extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == InputType.introduce.rawValue {
            textField.resignFirstResponder()
            return true
        } else if textField.tag == InputType.nickName.rawValue {
            introduceField.becomeFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.updateUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.updateUI()
    }
}

// MARK: - UI Init
extension ProfileEditViewController {
    
    private func pageLayoutInit() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.backgroundColor = .clear
        profileImageView.image = RadHelper.getProfileImage() ?? #imageLiteral(resourceName: "profileNon")
        
        profileImgSelectBtn.layer.cornerRadius = profileImgSelectBtn.frame.width / 2
        profileImgSelectBtn.layer.borderWidth = 1.0
        profileImgSelectBtn.layer.borderColor = UIColor.customBlackColor.cgColor
        
        nickNameField.makesToCustomField()
        nickNameField.tag = InputType.nickName.rawValue
        nickNameField.text = UserModel.profileName ?? UserModel.memberId
        
        introduceField.makesToCustomField()
        introduceField.tag = InputType.introduce.rawValue
        introduceField.text = UserModel.profileIntroStr
    }
}


// MARK: - Keyboard Protocol
extension ProfileEditViewController: keyboardNotiRegistProtocol {
    func keyboardShowAndHide(_ notification: Notification) {
        RadHelper.keyboardAnimation(notification, startBtnBottomConst) {
            self.view.layoutIfNeeded()
        }
    }
}


extension ProfileEditViewController: FMPhotoPickerViewControllerDelegate, PhotoEditorDelegate {
    func doneEditing(image: UIImage) {
        print("done editing \(image)")
    }
    
    func canceledEditing() {
        print("cancel Editing")
    }
    
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        print("photos \(photos)")
    }
}
