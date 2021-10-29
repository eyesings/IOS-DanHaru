//
//  JoinViewControllerr.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/26.
//

import Foundation
import UIKit

class JoinViewController: UIViewController {
    
    @IBOutlet var preBtn: UIButton!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var inputTypeLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var edgePanGestureRecong: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var emailErrorInfoMsg: UILabel!
    
    @IBOutlet var topNavView: UIView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var notchBottomView: UIView!
    
    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var startBtn: UIButton!
    
    @IBOutlet var stepProgressView: UIView!
    @IBOutlet var stepProgressViewArr: [UIView]!
    
    @IBOutlet var startBtnBottomConst: NSLayoutConstraint!
    @IBOutlet var progressParentView: NSLayoutConstraint!
    
    public var isFromLoginVC: Bool = false
    
    private var isEmailInputDone: Bool = false
    private var isIdInputDone: Bool = false
    private var isPWInputDone: Bool = false
    private var nowInputType: InputType = .email
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgePanGestureRecong.edges = .left
        
        closeBtn.isHidden = true
        inputTextField.makesToCustomField()
        changeTextField(type: .email)
        
        if isFromLoginVC { setLayoutMoveFromLogin() }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShowAndHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShowAndHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setLayoutMoveFromLogin() {
        preBtn?.isHidden = true
        closeBtn?.isHidden = false
    }
    
    // MARK: - Private Method
    
    // MARK: - OBJC Method
    @IBAction func onTapPreBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapNextBtn(_ sender: UIButton) {
        
        if inputTextField.hasText {
            if nowInputType == .email {
                if inputTextField.isValidEmail() {
                    nowInputType = .id
                } else {
                    print("이메일 형식이 아님")
                    inputTextField.fieldNotHasTextUI()
                    return
                }
            } else if nowInputType == .id {
                nowInputType = .pw
            } else if nowInputType == .pw {
                nowInputType = .done
            }
            changeTextField(type: nowInputType)
        } else {
            inputTextField.becomeFirstResponder()
            inputTextField.updateUI()
        }
    }
    
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized && nowInputType != .done {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onTapStartBtn(_ sender: UIButton) {
        print("main으로 이동")
        self.navigationController?.popToRootViewController(animated: true)
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

// MARK: - UI Method
extension JoinViewController {
    private func stepViewProgress() {
        for view in self.stepProgressViewArr
        {
            if let label = view as? UILabel
            {
                label.textColor = view.tag == self.nowInputType.rawValue ? .backgroundColor : .subLightColor
            }
            else
            {
                view.backgroundColor = view.tag == self.nowInputType.rawValue ? .subHeavyColor : .lightGrayColor
                view.layer.cornerRadius = view.frame.width / 2
            }
        }
    }
    
    private func changeTextField(type: InputType) {
        
        startBtn.isHidden = true
        signUpLabel.isHidden = true
        stepProgressView.isHidden = false
        
        inputTextField.text = nil
        inputTextField.updateUI(true)
        
        switch type {
        case .email:
            inputTypeLabel.text = "이메일"
            inputTextField.isSecureTextEntry = false
            inputTextField.keyboardType = .emailAddress
            inputTextField.placeholder = "이메일을 입력 해 주세요."
        case .id:
            inputTypeLabel.text = "아이디"
            inputTextField.isSecureTextEntry = false
            inputTextField.textContentType = .nickname
            inputTextField.keyboardType = .asciiCapable
            inputTextField.placeholder = "아이디를 입력 해 주세요."
        case .pw:
            inputTypeLabel.text = "비밀번호"
            inputTextField.isSecureTextEntry = true
            inputTextField.textContentType = .password
            inputTextField.keyboardType = .asciiCapable
            inputTextField.placeholder = "비밀번호를 입력 해 주세요."
        case .done:
            inputTypeLabel.isHidden = true
            inputTextField.isHidden = true
            topNavView.isHidden = true
            nextBtn.isHidden = true
            notchBottomView.isHidden = true
            
            startBtn.isHidden = false
            signUpLabel.isHidden = false
            
            startBtn.layer.cornerRadius = startBtn.frame.height / 2
            
            stepProgressView.isHidden = true
            
            view.endEditing(true)
        }
        
        stepViewProgress()
    }
}

// MARK: - UITextFieldDelegate
extension JoinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.hasText == true {
            onTapNextBtn(UIButton())
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.updateUI()
        
        if nowInputType == .email {
            if let textCnt = textField.text?.count {
                self.emailErrorInfoMsg.isHidden = textCnt > 0 ? textField.isValidEmail() : true
            }
            textField.fieldNotHasTextUI()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.updateUI()
    }
}
