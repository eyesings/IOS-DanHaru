//
//  ImageAuthShowCollectionViewCell.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/20.
//

import UIKit

class ImageAuthShowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var authImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    var onTapDeleteBtn: () -> Void = {  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authImage.image = nil
        authImage.contentMode = .scaleAspectFill
        onTapDeleteBtn = {}
        deleteBtn.backgroundColor = .mainColor
        deleteBtn.layer.cornerRadius = 15
        deleteBtn.layer.borderColor = UIColor.backgroundColor.cgColor
        deleteBtn.layer.borderWidth = 1.0
    }

    @IBAction func onTapDeleteBtn(_ sender: UIButton) {
        onTapDeleteBtn()
    }
}
