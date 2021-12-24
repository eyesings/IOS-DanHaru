//
//  SplashView.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/23.
//

import UIKit
import Lottie



class SplashView: UIView {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    
    private func loadXib() {
        let identifier = String(describing: type(of: self))
        
        guard let view = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as? UIView else { return }


        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        animationView.play()
        animationView.loopMode = .loop
        
        
        titleLabel.setTextWithTypeAnimation(typedText: titleLabel.text!)
    }
}

