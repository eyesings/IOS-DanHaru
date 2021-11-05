//
//  CustomToolBar.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/04.
//

import UIKit

/// Custom Toolbar 버튼 이벤트 delegate
protocol CustomToolBarDelegate {
    func ToolBarSelected(_ button: UIButton)
}

class CustomToolBar: UIToolbar {

    private var baseView: UIView!
    private var buttonList: [UIButton] = []
    private var indicatorList: [UIView] = []
    
    public var customDelegate: CustomToolBarDelegate?
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize: CGSize = super.sizeThatFits(size)
        newSize.height = RadHelper.deviceHasNotch ? 50 : 80
        
        return newSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        baseView.layer.cornerRadius = baseView.frame.height / 2
        baseView.createShadow(CGSize(width: 0, height: 0), 5)
        
        for indicator in indicatorList {
            indicator.layer.cornerRadius = indicator.frame.width / 2
        }
        
    }
    
    public func setSelectMenu(_ type: ToolBarBtnTag) {
        for btn in buttonList {
            if btn.tag == type.rawValue { onTapButton(btn) }
        }
    }
    
}

// MARK: - OBJC Method
extension CustomToolBar {
    
    @objc
    private func onTapButton(_ btn: UIButton) {
        for button in self.buttonList {
            button.isSelected = button == btn ? true : false
            hiddenToggleIndicator(button)
        }
        self.customDelegate?.ToolBarSelected(btn)
    }
}

// MARK: - UI Init Method
extension CustomToolBar {
    
    /// BaseView Init
    private func commonInit() {
        
        self.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        baseView = UIView()
        baseView.backgroundColor = .backgroundColor
        self.addSubview(baseView)
        
        baseView.snp.makeConstraints { view in
            view.centerX.equalTo(self)
            view.top.equalTo(self)
            view.width.equalTo(self).multipliedBy(0.4)
            view.height.equalTo(baseView.snp.width).multipliedBy(0.3)
        }
        
        initBtn()
    }
    
    /// ToolBarBtn Init
    private func initBtn() {
        for btnTypeTag in ToolBarBtnTag.allCases {
            createToolBarBtn(type: btnTypeTag)
        }
    }
    
    /// ToolBarBtn Create
    /// - Parameter type: ToolBarBtn Type
    private func createToolBarBtn(type: ToolBarBtnTag) {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tag = type.rawValue
        btn.addTarget(self, action: #selector(onTapButton(_:)), for: .touchUpInside)
         
        btn.setImage(type == .home ? #imageLiteral(resourceName: "mainOff") : #imageLiteral(resourceName: "userOff"), for: .normal)
        btn.setImage(type == .home ? #imageLiteral(resourceName: "mainOn") : #imageLiteral(resourceName: "userOn"), for: .selected)
        btn.setImage(type == .home ? #imageLiteral(resourceName: "mainOn") : #imageLiteral(resourceName: "userOn"), for: .highlighted)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: type == .home ? 30 : 15, bottom: 15, right: type == .home ? 15 : 30)
        
        baseView.addSubview(btn)
        
        btn.snp.makeConstraints { btn in
            if type == .home {
                btn.top.leading.bottom.equalTo(baseView)
                btn.trailing.equalTo(baseView.snp.centerX)
            } else if type == .myPage {
                btn.top.trailing.bottom.equalTo(baseView)
                btn.leading.equalTo(baseView.snp.centerX)
            }
        }
        
        createIndicatorView(for: btn)
        buttonList.append(btn)
    }
    
    /// BtnSelectedIndicator Create
    /// - Parameter btn: selectedBtn
    private func createIndicatorView(for btn: UIButton) {
        if let btnImgView = btn.imageView {
            let indicatorView = UIView()
            indicatorView.backgroundColor = .mainColor
            indicatorView.tag = btn.tag
            indicatorView.isHidden = true
            btn.addSubview(indicatorView)
            
            indicatorView.snp.makeConstraints { indicator in
                indicator.top.equalTo(btnImgView.snp.bottom).offset(3)
                indicator.centerX.equalTo(btnImgView)
                indicator.width.height.equalTo(btn.snp.width).multipliedBy(0.07)
            }
            
            self.indicatorList.append(indicatorView)
        }
    }
    
    /// Indicator SHOW/HIDE Toggle
    /// - Parameter btn: toolbar btn
    private func hiddenToggleIndicator(_ btn: UIButton) {
        for subview in btn.subviews {
            if subview.tag == btn.tag {
                subview.isHidden = !btn.isSelected
            }
        }
    }
}
