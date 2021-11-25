//
//  FMPresenterEditMenuView.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/27.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

class FMPresenterEditMenuView: UIView {
    private let editButton: UIButton
    
    public var onTapEditButton: (() -> Void)?
    
    init(config: FMPhotoPickerConfig) {
        editButton = UIButton()
        
        super.init(frame: .zero)
        
        self.addSubview(editButton)
        editButton.snp.makeConstraints { (btn) in
            btn.centerX.equalTo(self)
            btn.centerY.equalTo(self)
            btn.left.equalTo(self)
            btn.right.equalTo(self)
            btn.height.equalTo(40)
        }
        editButton.setTitleColor(UIColor(displayP3Red: 26/255.0, green: 63/255.0, blue: 102/255.0, alpha: 1), for: .normal)
        editButton.setTitle(config.strings["present_button_edit_image"], for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        editButton.addTarget(self, action: #selector(editButtonTarget), for: .touchUpInside)
        
        // top border view
        let topBorder = UIView(frame: .zero)
        topBorder.backgroundColor = kBorderColor
        addSubview(topBorder)
        
        topBorder.snp.makeConstraints { (top) in
            top.top.equalTo(self)
            top.left.equalTo(self)
            top.right.equalTo(self)
            top.height.equalTo(1)
        }
        
        self.backgroundColor = kTransparentBackgroundColor
    }
    
    @objc private func editButtonTarget() {
        onTapEditButton?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
