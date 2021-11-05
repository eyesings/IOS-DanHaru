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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShowAndHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShowAndHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - OBJC Method
    @IBAction func onTapMoveBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func onTapImageSelectBtn(_ sender: UIButton) {
    }
    
    @IBAction func onTapSaveBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
        // FIXME: user nickname and introduce send to server
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController()
        }
    }
    
    @IBAction func onTapScreenGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc
    func keyboardShowAndHide(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if sender.name == UIResponder.keyboardWillShowNotification {
                startBtnBottomConst.constant = -(keyboardHeight - RadHelper.bottomSafeAreaHeight)
            } else if sender.name == UIResponder.keyboardWillHideNotification {
                startBtnBottomConst.constant = 0
            }
            self.view.layoutIfNeeded()
        }
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
        nickNameField.text = UserModel.nickName ?? (UserModel.userIdx ?? "유저 이름")
        
        introduceField.makesToCustomField()
        introduceField.tag = InputType.introduce.rawValue
        introduceField.text = UserModel.profileIntro ?? "단 하루라도 열심히 살자"
    }
}
