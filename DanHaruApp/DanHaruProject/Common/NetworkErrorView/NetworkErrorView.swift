//
//  NetworkErrorView.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/30.
//

import UIKit
import Lottie


protocol NetworkErrorViewDelegate {
    func isNeedRetryService(_ type: APIType)
}

class NetworkErrorView {
    
    private let containerView: UIView
    var delegate: NetworkErrorViewDelegate?
    var isNeedRetry: Bool = true
    public var needRetryType: APIType?
    
    public static let shared = NetworkErrorView()
    private var animating = false
    
    private init() {
        
        let rootVC = (UIApplication.shared.keyWindow!.rootViewController)!
        
        containerView = UIView(frame: rootVC.view.frame)
        containerView.backgroundColor = .black.withAlphaComponent(0.4)
        
        commonInit()
    }
}

// MARK: - UI Layout Init
extension NetworkErrorView {
    private func commonInit() {
        
        let basicView = UIView()
        basicView.backgroundColor = .backgroundColor
        basicView.layer.cornerRadius = 20
        self.containerView.addSubview(basicView)
        
        basicView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.containerView)
            make.width.equalTo(self.containerView).multipliedBy(0.7)
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
    
    public func showNetworkView() {
        if self.animating { return }
        
        self.animating = true
        
        UIApplication.shared.keyWindow?.addSubview(self.containerView)
        self.containerView.isHidden = false
        self.containerView.alpha = 0
        
        
        UIView.animate(withDuration: 1.0) {
            self.containerView.alpha = 1.0
        }

    }
    
    @objc
    func retryConnectNetwork() {
        guard let retryType = self.needRetryType else { return }
        print("retry something \(retryType)")
        delegate?.isNeedRetryService(retryType)
        self.containerView.isHidden = true
        self.containerView.removeFromSuperview()
        self.animating = false
    }
    
    @objc
    private func closeApp() {
        exit(0)
    }
}
