//
//  CustomSegmentedControl.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/03.
//

import UIKit

protocol CustomSegmentedControlDelegate {
    func SegmentChanged(_ sender: UIButton)
}

@IBDesignable
class CustomSegmentedControl: UIView {
    var buttons = [UIButton]()
    var selector: UIView!
    var delegate: CustomSegmentedControlDelegate?
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var commaSeparatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    var _delegate: CustomSegmentedControlDelegate? = nil {
        didSet {
            delegate = _delegate
        }
    }
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        
        for (idx, buttonTitle) in buttonTitles.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.setTitleColor(textColor, for: .highlighted)
            button.tag = 200 + idx
            button.titleLabel?.font = .systemFont(ofSize: 15.0)
            button.addTarget(selector, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = 1.0 / CGFloat(buttons.count)
        selector = UIView()
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        
        addSubview(selector)
        
        selector.snp.makeConstraints { view in
            view.top.bottom.leading.equalTo(self)
            view.width.equalTo(self).multipliedBy(selectorWidth)
        }
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        addSubview(sv)
        
        sv.snp.makeConstraints { $0.top.left.right.bottom.equalTo(self) }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
        
    }
    
    @objc
    func buttonTapped(_ button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = selectorStartPosition
                }
                
                btn.setTitleColor(selectorTextColor, for: .normal)
                self.delegate?.SegmentChanged(btn)
            }
        }
    }

}
