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
    
    var todoIdx: Int = 0
    var todoTitle: String = ""
    
    private var checkImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "authCheck")
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .clear
        return imgView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        /*
        personAuthBtn.isHidden = false
        personAuthBtn.titleLabel?.font = .systemFont(ofSize: 13.0)
        personAuthBtn.titleLabel?.textColor = .customBlackColor
        personAuthBtn.layer.borderWidth = 1.0
        personAuthBtn.layer.cornerRadius = 10
        personAuthBtn.layer.borderColor = UIColor.customBlackColor.cgColor
        personAuthBtn.setTitle("재촉하기", for: .normal)
        
        personName.textColor = .customBlackColor
        */
        personAuthBtn.isUserInteractionEnabled = false
        self.addSubview(checkImgView)
        checkImgView.isHidden = true
        checkImgView.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(0.25)
            make.height.equalTo(checkImgView.snp.width)
            make.centerX.equalTo(self)
            make.top.equalTo(personName.snp.bottom).offset(10)
        }
        
        personImageView.layer.cornerRadius = personImageView.frame.height * 0.4
        
        self.backgroundColor = .clear
    }
    
    func authUserChangeUI(_ isAuth: Bool) {
        personAuthBtn.isHidden = isAuth
        checkImgView.isHidden = !isAuth
    }

    @IBAction func personAuthButtonAction(_ sender: UIButton) {
        print("재촉하기 버튼")
        /*
        //FIXME: 텍스트 얼렛 뷰로 푸시 내용을 사용자가 직접 정할 수 있음
        if let topVC = UIApplication.topViewController() {
            
            let alertController = UIAlertController.init(title: "푸시 내용을 입력해주세요.", message: "", preferredStyle: .alert)
            alertController.addTextField { (txtField) in
                txtField.text = ""
            }
            let cancelAction = UIAlertAction.init(title: RadMessage.buttonFalse, style: .cancel)
            let defaultAction = UIAlertAction.init(title: RadMessage.buttonTrue, style: .default) { (defaultAciton) in
                let textFt = alertController.textFields?.first?.text
                
                ViewModelService.todoSubjectSendPush(RadMessage.basicTitle, textFt ?? "", self.todoIdx)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            
            DispatchQueue.main.async {
                topVC.present(alertController, animated: true, completion: nil)
            }
            
            
        }
        */
        
        //ViewModelService.todoSubjectSendPush(RadMessage.basicTitle, self.todoTitle + "에 오셔서 인증해주세요.", self.todoIdx)
        
    }
}
