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
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageLayoutInit()
        
        self.registerKeyboardNotification()
    }
    
    private func config() -> FMPhotoPickerConfig {
        var config = FMPhotoPickerConfig()
        
        config.selectMode = .single
        config.maxImage = 1
        config.availableCrops = [FMCrop.ratioSquare]
        
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
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTapSaveBtn(_ sender: UIButton) {
        
        _ = UserProfileUpdateViewModel.init(editedName: nickNameField.text?.encodeEmoji() ?? "",
                                            editedIntro: introduceField.text?.encodeEmoji() ?? "",
                                            editedImg: selectedImage) {
            
            self.navigationController?.popViewController()
            RadHelper.getRootViewController { vc in
                if let rootVc = vc
                {
                    RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                                    message: RadMessage.ProfileEdit.saveProfile,
                                                                    isNeedCancel: false,
                                                                    viewController: rootVc)
                }
            }
        } errHandler: { Dprint("error \($0)") }
        
        
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
        textField.updateUI(textField == self.introduceField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.updateUI(textField == self.introduceField)
    }
}

// MARK: - UI Init
extension ProfileEditViewController {
    
    private func pageLayoutInit() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.backgroundColor = .clear
        RadHelper.getProfileImage { img in
            DispatchQueue.main.async {
                self.profileImageView.image = img
            }
        }
        profileImageView.contentMode = .scaleAspectFill
        
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


extension ProfileEditViewController: FMPhotoPickerViewControllerDelegate {
    
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        print("photos \(photos)")
        self.selectedImage = photos.first
        self.profileImageView.image = photos.first
    }
}
