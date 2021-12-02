//
//  MyChallengeCell.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/08.
//

import UIKit

class MyChallengeCell: UICollectionViewCell {
    
    @IBOutlet var challengeTitleLabelList: [UILabel]!
    @IBOutlet var dateDotViewList: [UIView]!
    
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if RadHelper.isIphoneSE1st {
            challengeTitleLabelList.forEach { $0.font = UIFont.systemFont(ofSize: 14.0) }
        }
        
        self.layer.cornerRadius = 20
        
        dateDotViewList.forEach { $0.isHidden = true }
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .subLightColor
        
        dateDotViewList.forEach {
            $0.isHidden = false
            $0.layer.cornerRadius = $0.frame.height / 2
        }
        
        cellDateLabel.text = "10.28,2021"
        
        if let titleStr = cellTitle?.text {
            let attrStr = NSMutableAttributedString(string: titleStr)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attrStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrStr.length))
            cellTitle?.attributedText = attrStr
        }
    }
}
