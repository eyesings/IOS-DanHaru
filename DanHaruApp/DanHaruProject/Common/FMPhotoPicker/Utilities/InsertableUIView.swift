//
//  InsertableUIView.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/06.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

protocol InsertableUIView {
    func insert(toView parentView: UIView)
}

extension InsertableUIView where Self: UIView {
    internal func insert(toView parentView: UIView) {
        parentView.addSubview(self)
        
        self.snp.makeConstraints { (insertView) in
            insertView.top.equalTo(parentView)
            insertView.left.equalTo(parentView)
            insertView.bottom.equalTo(parentView)
            insertView.right.equalTo(parentView)
        }
    }
}

extension UIView: InsertableUIView {}
