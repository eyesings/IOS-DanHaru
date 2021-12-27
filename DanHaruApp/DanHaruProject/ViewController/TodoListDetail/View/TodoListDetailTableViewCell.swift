//
//  TodoListDetailTableViewCell.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/09.
//

import UIKit

class TodoListDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var weeklyBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
