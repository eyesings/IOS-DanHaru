//
//  TodoListTableViewCell.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/25.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {

    @IBOutlet weak var rounderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet var challengeTodoImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rounderView.layer.cornerRadius = 15
        
        let tintedImage = UIImage(named: "personFill")?.withRenderingMode(.alwaysTemplate)
        self.challengeTodoImgView.image = tintedImage
        self.challengeTodoImgView.tintColor = UIColor.init(red: 37 / 255, green: 49 / 255, blue: 56 / 255, alpha: 0.2)
        self.challengeTodoImgView.isHidden = true
    }
    
}
