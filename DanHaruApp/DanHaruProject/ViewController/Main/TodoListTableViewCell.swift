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
    @IBOutlet weak var cellBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rounderView.layer.cornerRadius = 20
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
