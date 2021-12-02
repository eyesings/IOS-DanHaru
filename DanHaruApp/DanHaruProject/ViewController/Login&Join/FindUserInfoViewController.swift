//
//  FindUserInfoViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/29.
//

import Foundation
import UIKit

class FindUserInfoViewController: UIViewController {
    
    @IBOutlet var idFindView: UIView!
    @IBOutlet var pwFindView: UIView!
    @IBOutlet var findView: UIView!
    
    @IBOutlet var emailInputTextField: UITextField!
    @IBOutlet var confirmValInputTextField: UITextField!
    
    @IBOutlet var userIdText: UILabel!
    @IBOutlet var copyIdInfoLabel: UILabel!
    @IBOutlet var postEmailInfoLabel: UILabel!
    @IBOutlet var postConfirmNumInfoLabel: UILabel!
    
    @IBOutlet var postCertificateNum: UIButton!
    @IBOutlet var confirmCertificateNum: UIButton!
    
    private let warningView = WarningView.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdText.isHidden = true
        copyIdInfoLabel.isHidden = true
        findView.isHidden = true
        postEmailInfoLabel.isHidden = true
        postConfirmNumInfoLabel.isHidden = true
        
//        updateBtnUI(confirmCertificateNum, isEnable: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        idFindView.findUserViewInit()
        pwFindView.findUserViewInit()
        
        emailInputTextField.makesToCustomField(customWidth: screenwidth * 0.6)
        confirmValInputTextField.makesToCustomField(customWidth: screenwidth * 0.6)
        
    }
    
    @IBAction func onTapPostCertificationNumberBtn(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if emailInputTextField.isValidEmail() {
//            updateBtnUI(postCertificateNum, isEnable: false)
//            updateBtnUI(confirmCertificateNum, isEnable: true)
            
            
            // FIXME: do Post Certification Number API
            // FIXME: IS SUCCESS
            postEmailInfoLabel.isHidden = false
            confirmValInputTextField.becomeFirstResponder()
            
            postConfirmNumInfoLabel.isHidden = true
            confirmValInputTextField.text = nil
        } else {
            warningView.message = RadMessage.UserJoin.notValidEmail
            warningView.showAndAutoHide()
        }
    }
    
    @IBAction func onTapConfirmCertificationNumberBtn(_ sender: UIButton) {
//        updateBtnUI(confirmCertificateNum, isEnable: false)
        
        guard let inputText = confirmValInputTextField.text else { self.view.endEditing(true); return }
        postConfirmNumInfoLabel.isHidden = !inputText.isEmpty
        if inputText.isEmpty == true { return }
        
        // FIXME: Certification Number is Correct
        findView.isHidden = false
        self.view.endEditing(true)
    }
    
    @IBAction func onTapFindIDBtn(_ sender: UIButton) {
        // FIXME: do find id API
        
        // FIXME: find API, show userIdText
        setUserIdTextLabel("blahblah")
    }
    
    @IBAction func onTapFindPWBtn(_ sender: UIButton) {
        
        userIdText.isHidden = true
        copyIdInfoLabel.isHidden = true
        
        let alertVC = UIAlertController(title: RadMessage.AlertView.inputPasswordTitle,
                                        message: RadMessage.title,
                                        preferredStyle: .alert)
        
        let submit = UIAlertAction(title: RadMessage.AlertView.change, style: .default) { _ in
            if let textField = alertVC.textFields?.first {
                if let inputText = textField.text {
                    // FIXME: do password change api
                } else {
                    self.warningView.message = RadMessage.FindUserInfo.inputReSetPW
                }
            }
        }
        
        let cancel = UIAlertAction(title: RadMessage.buttonFalse, style: .cancel, handler: nil)
        
        alertVC.addTextField { textField in
            textField.textAlignment = .center
            textField.isSecureTextEntry = true
            textField.placeholder = "비밀번호"
            textField.textColor = .customBlackColor
        }
        
        alertVC.addAction(submit)
        alertVC.addAction(cancel)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onTapCopyTextBtn(_ sender: UIButton) {
        UIPasteboard.general.string = getIdFromTextLabel()
        
        DispatchQueue.main.async {
            let warning = WarningView.shared
            warning.message = RadMessage.FindUserInfo.copyID
            warning.showAndAutoHide()
        }
        
    }
    
    
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapScreenGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}


// MARK: - Method
extension FindUserInfoViewController {
    
    // MARK: Init
    private func setUserIdTextLabel(_ idText: String) {
        
        let idInfoText = "\(RadMessage.FindUserInfo.preFindId)\(idText)\(RadMessage.FindUserInfo.sufFindId)"
        
        let font = UIFont(name: RadMessage.FindUserInfo.fontName, size: 24) ?? UIFont.boldSystemFont(ofSize: 25)
        
        let attributedStr = NSMutableAttributedString(string: idInfoText)
        
        attributedStr.addAttributes([.font:font,
                                     .foregroundColor:UIColor.subHeavyColor]
                                    , range: (idInfoText as NSString).range(of: idText))
        
        userIdText.attributedText = attributedStr
        
        userIdText.isHidden = false
        copyIdInfoLabel.isHidden = false
    }
    
    // MARK: Private
    private func getIdFromTextLabel() -> String {
        guard let containSuffix = userIdText.text?.components(separatedBy: RadMessage.FindUserInfo.preFindId).last,
              let findIdText = containSuffix.components(separatedBy: RadMessage.FindUserInfo.sufFindId).first
        else { return "" }
        
        return findIdText
    }
    
    private func updateBtnUI(_ btn: UIButton, isEnable: Bool) {
        btn.isEnabled = isEnable
        btn.backgroundColor = isEnable ? .subHeavyColor : .lightGrayColor
        btn.setTitleColor(isEnable ? .backgroundColor : .white, for: .normal)
    }
}
