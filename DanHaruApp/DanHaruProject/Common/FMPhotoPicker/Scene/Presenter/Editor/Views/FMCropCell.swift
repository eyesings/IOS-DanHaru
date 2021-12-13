//
//  FMCropCell.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/09.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

class FMCropCell: UICollectionViewCell {
    static let reussId = String(describing: self)
    public var imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { view in
            view.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    public func setSelected() {
        let tintedImage = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.image = tintedImage
        imageView.tintColor = kHighLightColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
