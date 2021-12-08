//
//  NetworkErrorView.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/30.
//

import UIKit
import Lottie


protocol NetworkErrorViewDelegate {
    func isNeedRetryService()
}

class NetworkErrorView: UIView {
    
    var delegate: NetworkErrorViewDelegate?
    var isNeedRetry: Bool = false
    
    public init(frame: CGRect, isNeedRetry retry: Bool = false) {
        super.init(frame: frame)
        isNeedRetry = retry
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - UI Layout Init
extension NetworkErrorView {
    func commonInit() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        
        let basicView = UIView()
        basicView.backgroundColor = .backgroundColor
        basicView.layer.cornerRadius = 20
        self.addSubview(basicView)
        
        basicView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.7)
            make.height.equalTo(basicView.snp.width).multipliedBy(1.3)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .customBlackColor
        titleLabel.text = RadMessage.Network.networkErr
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20.0)
        basicView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(basicView.snp.centerY)
            make.leading.trailing.equalTo(basicView)
            make.height.equalTo(30)
        }
        
        let animateView = AnimationView(name: "caution_black")
        animateView.play()
        animateView.loopMode = .loop
        animateView.contentMode = .scaleAspectFill
        basicView.addSubview(animateView)
        
        animateView.snp.makeConstraints { make in
            make.width.equalTo(basicView).multipliedBy(0.7)
            make.height.equalTo(animateView.snp.width)
            make.centerX.bottom.equalTo(titleLabel)
        }
        
        
        let retryBtn = UIButton(type: .custom)
        retryBtn.setTitle("재시도", for: .normal)
        retryBtn.setTitleColor(.backgroundColor, for: .normal)
        retryBtn.titleLabel?.font = .systemFont(ofSize: 15.0)
        retryBtn.backgroundColor = .customBlackColor
        retryBtn.layer.cornerRadius = 10
        retryBtn.addTarget(self, action: #selector(retryConnectNetwork), for: .touchUpInside)
        basicView.addSubview(retryBtn)
        
        retryBtn.snp.makeConstraints { make in
            make.width.equalTo(basicView).multipliedBy(0.6)
            make.height.equalTo(basicView).multipliedBy(0.1)
            make.centerX.equalTo(basicView)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        retryBtn.isHidden = !isNeedRetry
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setTitle("앱 종료", for: .normal)
        closeBtn.setTitleColor(.heavyGrayColor, for: .normal)
        closeBtn.titleLabel?.font = .systemFont(ofSize: 15.0)
        closeBtn.layer.cornerRadius = 10
        closeBtn.layer.borderWidth = 1.0
        closeBtn.layer.borderColor = UIColor.heavyGrayColor.cgColor
        closeBtn.addTarget(self, action: #selector(closeApp), for: .touchUpInside)
        basicView.addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(retryBtn)
            make.top.equalTo(retryBtn.snp.bottom).offset(5)
        }
        
        
    }
    
    @objc
    func retryConnectNetwork() {
        NotificationCenter.default.post(name: Configs.NotificationName.networkRetryConnect, object: nil)
        print("retry something")
        self.removeFromSuperview()
    }
    
    @objc
    private func closeApp() {
        exit(0)
    }
}
