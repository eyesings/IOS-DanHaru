//
//  FMPresenterBottomView.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/19.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
import AVKit

class FMPresenterBottomView: UIView {
    // should be false when the view is hidden
    private var shouldReceiveUpdate = true
    
    public var editMenuView: FMPresenterEditMenuView
    
    public var onTapEditButton: () -> Void = {} {
        didSet { self.editMenuView.onTapEditButton = self.onTapEditButton }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: FMPhotoPickerConfig) {
        editMenuView = FMPresenterEditMenuView(config: config)
        super.init(frame: .zero)
        
        self.addSubview(editMenuView)
        editMenuView.snp.makeConstraints { (editMenu) in
            editMenu.height.equalTo(46)
            editMenu.left.equalTo(self)
            editMenu.right.equalTo(self)
            editMenu.bottom.equalTo(self)
        }
    }
    
    public func videoMode() {
        editMenuView.isHidden = true
        self.shouldReceiveUpdate = true
    }
    
    public func imageMode() {
        editMenuView.isHidden = false
        self.shouldReceiveUpdate = false
    }
}
