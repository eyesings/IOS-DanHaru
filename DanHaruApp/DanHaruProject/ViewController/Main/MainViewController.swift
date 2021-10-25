//
//  ViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import UIKit
import Lottie


class MainViewController: UIViewController {

    var dateLabel = UILabel()
    
    let calendarShowBtn = AnimationView(name: "3442-scroll")
    
    var addButton = UIButton()
    
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }

    func setUI() {
        
        self.view.addSubview(dateLabel)
        formatter.dateFormat = "yyyy-MM-dd"
        var current_date_string = formatter.string(from: Date())
        dateLabel.text = current_date_string
        
        
    }
    

}

