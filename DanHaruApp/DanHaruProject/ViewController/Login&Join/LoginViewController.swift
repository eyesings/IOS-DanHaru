//
//  LoginViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/26.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var idInputTextField: UITextField!
    @IBOutlet var pwInputTextField: UITextField!
    @IBOutlet var startBtnBottomConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in textFields {
            textField.makesToCustomField()
        }
        
        self.registerKeyboardNotification()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToMain), name: Configs.NotificationName.userLoginSuccess, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for field in textFields {
            field.updateUI(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        NotificationCenter.default.removeObserver(self, name: Configs.NotificationName.userLoginSuccess, object: nil)
    }
    
    // MARK: - OBJC Method
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapStartBtn(_ sender: UIButton) {

        if idInputTextField.hasText == false {
            idInputTextField.becomeFirstResponder()
        } else if pwInputTextField.hasText == false {
            pwInputTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            let _ = UserInfoViewModel.init(idInputTextField.text!, pwInputTextField.text!)
            RadHelper.getRootViewController()?.showLoadingView()
        }
        
        idInputTextField.updateUI()
        pwInputTextField.updateUI()
    }
    
    @IBAction func onTapJoinBtn(_ sender: UIButton) {
        if let joinVC = RadHelper.getVCFromUserJoinSB(withID: StoryBoardRef.joinVC) as? JoinViewController {
            joinVC.isFromLoginVC = true
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
    }
    
    @IBAction func onTapFindInfoBtn(_ sender: UIButton) {
        if let findVC = RadHelper.getVCFromUserJoinSB(withID: StoryBoardRef.findVC) as? FindUserInfoViewController {
            findVC.modalPresentationStyle = .fullScreen
            self.present(findVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onTapScreenGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    private func moveToMain() {
        RadHelper.rootVcChangeToMain()
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == InputType.pw.rawValue {
            onTapStartBtn(UIButton())
            return true
        }
        
        for field in textFields {
            if textField.tag != field.tag
            {
                field.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.updateUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.updateUI()
    }
}


// MARK: - Keyboard Protocol
extension LoginViewController: keyboardNotiRegistProtocol {
    func keyboardShowAndHide(_ notification: Notification) {
        RadHelper.keyboardAnimation(notification, startBtnBottomConst, isUpdateToHihger: true) {
            self.view.layoutIfNeeded()
        }
    }
}
