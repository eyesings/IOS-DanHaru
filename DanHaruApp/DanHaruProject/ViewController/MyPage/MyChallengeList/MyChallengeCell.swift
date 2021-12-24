//
//  MyChallengeCell.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/08.
//

import UIKit

class MyChallengeCell: UICollectionViewCell {
    
    @IBOutlet var dateDotViewList: [UIView]!
    
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellDateLabel: UILabel!
    @IBOutlet weak var cellDotView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if RadHelper.isIphoneSE1st {
            cellTitle.font = .systemFont(ofSize: 14.0)
        }
        
        self.layer.cornerRadius = 20
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellDotView.layer.cornerRadius = cellDotView.frame.height / 2
        
        if let titleStr = cellTitle?.text {
            let attrStr = NSMutableAttributedString(string: titleStr)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attrStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrStr.length))
            cellTitle?.attributedText = attrStr
        }
    }
    
    func changeColorByUse(_ isUse: Bool) {
        cellDotView.backgroundColor = isUse ? .heavyGrayColor : .highlightHeavyColor
        backgroundColor = isUse ? RadHelper.colorFromHex(hex: "dddddd") : .subLightColor
        cellTitle.textColor = isUse ? .lightGrayColor : .customBlackColor
        cellDateLabel.textColor = isUse ? .lightGrayColor : .heavyGrayColor
    }
}
