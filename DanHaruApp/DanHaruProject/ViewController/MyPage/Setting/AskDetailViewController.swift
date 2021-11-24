//
//  AskDetailViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/15.
//

import UIKit



class AskDetailViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var askInputTextView: UITextView!
    @IBOutlet var askPostBtnTopConst: NSLayoutConstraint!
    @IBOutlet var askPostBtn: UIButton!
    
    private var inputTextStr: String = ""
    private var btnBottomConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initLayout()
        
        self.registerKeyboardNotification()
    }
    
    @IBAction func onTapDoneBtn(_ sender: UIButton = UIButton()) {
        if checkEmailInputTextField() && checkAskInputTextView() { dismissAndAddAsk() }
    }
    
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapScreenGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - Methods
extension AskDetailViewController {
    
    private func dismissAndAddAsk() {
        self.dismiss(animated: true) {
            RadHelper.getRootViewController { vc in
                guard let rootVc = vc else { return }
                RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title, message: RadMessage.ASK.askAddSuccess, isNeedCancel: false, viewController: rootVc)
            }
        }
    }
    
    private func checkEmailInputTextField() -> Bool {
        
        if emailTextField.text?.isEmpty == true {
            let radMsgASK = RadMessage.ASK.self
            let alertMsg = RadHelper.isLogin ? radMsgASK.emailNotInputErrIsLogin : radMsgASK.emailNotInputErrNoneLogin
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title,
                                                            message: alertMsg,
                                                            isNeedCancel: true, viewController: self) { isCheck in
                if isCheck
                {
                    if RadHelper.isLogin {
                        print("현재 로그인한 계정으로 등록 됨")
                        self.emailTextField.text = UserModel.memberEmail
                        self.onTapDoneBtn()
                    } else {
                        self.emailTextField.becomeFirstResponder()
                    }
                }
            }
            return false
        } else {
            guard emailTextField.isValidEmail() else {
                RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title, message: RadMessage.ASK.emailError, isNeedCancel: false, viewController: self)
                return false
            }
            return true
        }
    }
    
    private func checkAskInputTextView() -> Bool {
        
        if askInputTextView.text.count < 10 || askInputTextView.text == RadMessage.ASK.textViewInfoStr {
            
            RadAlertViewController.basicAlertControllerShow(WithTitle: RadMessage.title, message: RadMessage.ASK.askTextCntErr, isNeedCancel: false, viewController: self)
            
            return false
        } else {
            return true
        }
    }
}

// MARK: - UI Init
extension AskDetailViewController {
    private func initLayout() {
        emailTextField.makesToCustomField(customWidth: screenwidth*0.5)
        emailTextField.text = UserModel.memberEmail
        
        askInputTextView.layer.borderWidth = 0.5
        askInputTextView.layer.borderColor = UIColor.heavyGrayColor.cgColor
        inputPlaceholderOnTextView(askInputTextView)
        
        btnBottomConst = askPostBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        btnBottomConst.isActive = false
    }
}

// MARK: - UITextView Delegate
extension AskDetailViewController: UITextViewDelegate {
    
    private func inputPlaceholderOnTextView(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = RadMessage.ASK.textViewInfoStr
            textView.textColor = .heavyGrayColor
        } else {
            textView.text = inputTextStr
            textView.textColor = .customBlackColor
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text != RadMessage.ASK.textViewInfoStr { inputTextStr = textView.text }
        inputPlaceholderOnTextView(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            inputPlaceholderOnTextView(textView)
        }
    }
}


// MARK: - Keyboard Protocol
extension AskDetailViewController: keyboardNotiRegistProtocol {
    func keyboardShowAndHide(_ notification: Notification) {
        RadHelper.keyboardAnimation(notification, askPostBtnTopConst, forCustom: true) {
            let isShowKeyboard = notification.name == UIResponder.keyboardWillShowNotification
            self.askPostBtnTopConst.isActive = !isShowKeyboard
            self.btnBottomConst.isActive = isShowKeyboard
            self.btnBottomConst.constant = -(keyboardH + 10)
            self.view.layoutIfNeeded()
        }
    }
}
