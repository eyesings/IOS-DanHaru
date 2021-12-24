//
//  LoginViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/26.
//

import Foundation
import UIKit
import Lottie
import SnapKit

class HomeViewController: UIViewController {
    
    private var btnHeight: CGFloat = 44.0
    private var btnWidth: CGFloat = 0.0
    private var btnSpacing: CGFloat = 8.0
    private let splashViewDuration: Double = 2.0
    
    private var loginAnimationView: AnimationView!
    private var loginBtn: UIButton!
    private var joinBtn: UIButton!
    
    private let mainTitle    = "단 하루,\n나를 바꾸는 습관"
    private let lgnBtnTitle  = "로그인"
    private let joinBtnTitle = "회원가입"
    private let nextBtnTitle = "다음에 할래요"
    
    public var needMovePageID: String = ""
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnWidth = self.view.frame.width * 0.8
        
        initViewLayout()
        
        if needMovePageID == StoryBoardRef.loginVC {
            onTapLoginBtn()
        } else if needMovePageID == StoryBoardRef.joinVC {
            onTapJoinBtn()
        }
        
        self.perform(#selector(splashViewRemove), with: nil, afterDelay: TimeInterval(splashViewDuration))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginAnimationView.play()
    }
    
    
}

// MARK: - OBJC Method
extension HomeViewController {
    @objc
    func onTapLoginBtn() {
        if let loginVC = RadHelper.getVCFromUserJoinSB(withID: StoryBoardRef.loginVC) as? LoginViewController {
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @objc
    func onTapJoinBtn() {
        if let joinVC = RadHelper.getVCFromUserJoinSB(withID: StoryBoardRef.joinVC) as? JoinViewController {
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
    }
    
    @objc
    func onTapNextTimeBtn() {
        UserDefaults.standard.saveUserInputVal(id: RadHelper.tempraryID, pw: "1")
        let _ = UserJoinViewModel.init("\(RadHelper.tempraryID)@example.com", "\(RadHelper.tempraryID)", "1") { type in
            print("has error \(type)")
        }
        RadHelper.rootVcChangeToMain()
    }
    
    @objc
    func splashViewRemove() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.splashViewDuration * 0.5) {
                self.appDelegate.splashView.alpha = 0.0
            } completion: { _ in
                self.appDelegate.splashView.removeFromSuperview()
            }
        }
    }
}

// MARK: - UI Init Func
extension HomeViewController {
    
    func getStoryBoardVC(withId: String) -> UIViewController {
        return UIStoryboard(name: "UserJoinSB", bundle: nil).instantiateViewController(withIdentifier: withId)
    }
    
    func initViewLayout() {
        initLoginAnimationView()
        initLoginLabel()
        initLoginBtn()
        initJoinBtn()
        initNextTimeBtn()
    }
    
    func initLoginAnimationView() {
        loginAnimationView = AnimationView(name: "loginAnimation")
        loginAnimationView.contentMode = .scaleAspectFill
        self.view.addSubview(loginAnimationView)
        
        loginAnimationView.play()
        loginAnimationView.loopMode = .loop
        
        loginAnimationView.snp.makeConstraints { view in
            view.width.centerX.equalTo(self.view)
            view.height.equalTo(self.view.frame.width)
            view.centerY.equalTo(self.view).multipliedBy(0.85)
        }
    }
    
    func initLoginLabel() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = mainTitle
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 38.0, weight: .black)
        titleLabel.textColor = .customBlackColor
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { label in
            label.width.equalTo(btnWidth)
            label.height.equalTo(self.view).multipliedBy(0.2)
            label.centerX.equalTo(self.view)
            label.centerY.equalTo(self.view).multipliedBy(0.63)
        }
    }
    
    func initLoginBtn() {
        loginBtn = UIButton()
        loginBtn.setTitle(lgnBtnTitle, for: .normal)
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        loginBtn.setTitleColor(.subHeavyColor, for: .normal)
        loginBtn.backgroundColor = .clear
        loginBtn.layer.cornerRadius = btnHeight / 2
        loginBtn.layer.borderWidth = 2
        loginBtn.layer.borderColor = UIColor.subHeavyColor.cgColor
        loginBtn.addTarget(self, action: #selector(self.onTapLoginBtn), for: .touchUpInside)
        self.view.addSubview(loginBtn)
        
        loginBtn.snp.makeConstraints { btn in
            btn.width.equalTo(btnWidth)
            btn.height.equalTo(btnHeight)
            btn.centerX.equalTo(self.view)
            btn.centerY.equalTo(self.view).multipliedBy(1.56)
        }
    }
    
    func initJoinBtn() {
        joinBtn = UIButton()
        joinBtn.setTitle(joinBtnTitle, for: .normal)
        joinBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        joinBtn.setTitleColor(.backgroundColor, for: .normal)
        joinBtn.backgroundColor = .subHeavyColor
        joinBtn.layer.cornerRadius = btnHeight / 2
        joinBtn.addTarget(self, action: #selector(self.onTapJoinBtn), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        
        joinBtn.snp.makeConstraints { btn in
            btn.width.equalTo(btnWidth)
            btn.height.equalTo(btnHeight)
            btn.centerX.equalTo(self.view)
            btn.top.equalTo(loginBtn.snp.bottom).offset(btnSpacing)
        }
    }
    
    func initNextTimeBtn() {
        let nextTimeBtnLabelAttribute: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.heavyGrayColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let nextTimeBtnAttributeStr = NSMutableAttributedString(string: nextBtnTitle, attributes: nextTimeBtnLabelAttribute)
        
        let nextTimeBtn = UIButton()
        nextTimeBtn.setAttributedTitle(nextTimeBtnAttributeStr, for: .normal)
        nextTimeBtn.addTarget(self, action: #selector(self.onTapNextTimeBtn), for: .touchUpInside)
        self.view.addSubview(nextTimeBtn)
        
        nextTimeBtn.snp.makeConstraints { btn in
            btn.width.equalTo(btnWidth).multipliedBy(0.5)
            btn.height.equalTo(self.view).multipliedBy(0.02)
            btn.centerX.equalTo(self.view)
            btn.top.equalTo(joinBtn.snp.bottom).offset(btnSpacing)
        }
    }
}
