//
//  BottomSheetViewController.swift
//  DanHaruProject
//
//  Created by RADCNS_DESIGN on 2021/10/26.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController {

    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        return view
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    var defaultHeight: CGFloat = 0.0
    
    private var bottomSheetPanStartingTopConstant: CGFloat = 30.0
    
    private let contentViewController: UIViewController
    
    
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaultHeight = self.view.frame.height / 2
        
        setupUI()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    private func setupUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)

        addChild(contentViewController)
        bottomSheetView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        bottomSheetView.clipsToBounds = true
        
        dimmedView.alpha = 0.0
        
        setupLayout()
    }
    
    private func setupLayout() {
        /*
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        dimmedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        dimmedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        */
        
        dimmedView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        
        
        //bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        //bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor,constant:topConstant)
        //bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: topConstant)
        //bottomSheetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        //bottomSheetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        //bottomSheetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        //NSLayoutConstraint.activate([bottomSheetViewTopConstraint])
        
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(topConstant)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        
        
        /*
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor).isActive = true
        contentViewController.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor).isActive = true
        contentViewController.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor).isActive = true
        */
        
        contentViewController.view.snp.makeConstraints { make in
            make.top.equalTo(bottomSheetView)
            make.leading.equalTo(bottomSheetView)
            make.trailing.equalTo(bottomSheetView)
            make.bottom.equalTo(bottomSheetView)
        }
        
        
    }
    
    
    private func showBottomSheet() {
        
        let safeAreaHeight:CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding:CGFloat = view.safeAreaInsets.bottom
        
        let constant = (safeAreaHeight + bottomPadding) - self.defaultHeight
        print("높이 \(constant)")
        self.bottomSheetView.snp.remakeConstraints { make in
            make.top.equalTo(self.view).offset(constant)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: constant)
            self.view.layoutIfNeeded()
            
        } completion: { (_) in
            
        }
    }
    
    private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha:CGFloat = 0.7
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2
        
        let noDimPosition = safeAreaHeight + bottomPadding
        
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * ( 1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.velocity(in: view)
        
        print("유저가 위아래로 : \(translation.y) : 만큼 드래그")
        /*
        if velocity.y > 1500 {
            hideBottomSheetAndGoBack()
            return
        }
        */
       
        let safeAreaHeight:CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding:CGFloat = view.safeAreaInsets.bottom
        
        if translation.y > 0 {
            
            switch panGestureRecognizer.state {
                case .began:
                    //bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
                    //bottomSheetPanStartingTopConstant = safeAreaHeight + bottomPadding - defaultHeight
                    break
                case .changed:
                    
                    //bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
                    bottomSheetView.snp.remakeConstraints { make in
                        make.top.equalTo(self.view).offset(safeAreaHeight + bottomPadding - defaultHeight + translation.y)
                        make.leading.equalTo(self.view)
                        make.trailing.equalTo(self.view)
                        make.height.equalTo(self.view)
                    }
                    
                case .ended:
                    print("드래그가 끝남")
                    
                    if translation.y >= self.view.frame.height / 3 {
                        hideBottomSheetAndGoBack()
                    }
                    
                    showBottomSheet()
                    
                default:
                    break
            }
        }
        
        
        
    }
    
    func hideBottomSheetAndGoBack() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
