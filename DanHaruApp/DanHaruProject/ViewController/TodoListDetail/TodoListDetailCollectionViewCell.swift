//
//  TodoListDetailCollectionViewCell.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/11/04.
//

import UIKit

class TodoListDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personAuthBtn: UIButton!
    @IBOutlet weak var checkTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    @IBAction func personAuthButtonAction(_ sender: UIButton) {
        print("재촉하기 버튼")
        
    }
}
