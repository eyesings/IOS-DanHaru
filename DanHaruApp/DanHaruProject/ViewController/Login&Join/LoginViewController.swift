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
    @IBOutlet var edgePanGestureRecong: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var startBtnBottomConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgePanGestureRecong.edges = .left
        
        for textField in textFields {
            textField.makesToCustomField()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShowAndHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShowAndHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            print("main으로 이동")
//            self.navigationController?.popToRootViewController(animated: true)
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
            self.navigationController?.pushViewController(findVC, animated: true)
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

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == InputType.pw.rawValue {
            textField.resignFirstResponder()
            onTapStartBtn(UIButton())
            return true
        }
        
        for field in textFields {
            if textField.tag != field.tag
            {
                field.becomeFirstResponder()
            }
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
