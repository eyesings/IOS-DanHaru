//
//  MyChallengeListViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/03.
//

import UIKit


class MyChallengeListViewController: UIViewController {
    
    @IBOutlet var customSegment: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customSegment.delegate = self
    }
    
    // MARK: - OBJC Method
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController()
        }
    }
}

// MARK: - CustomSegment Delegate
extension MyChallengeListViewController: CustomSegmentedControlDelegate {
    func SegmentChanged(_ sender: UIButton) {
        switch sender.tag {
        case MyChallangeBtnTag.todoList.rawValue:
            print("todolist")
        case MyChallangeBtnTag.myChallange.rawValue:
            print("challenge")
        default:
            print("not either")
        }
    }
}
