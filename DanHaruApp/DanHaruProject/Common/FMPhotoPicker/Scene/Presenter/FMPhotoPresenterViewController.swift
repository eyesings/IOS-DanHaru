//
//  FMPhotoPresenterViewController.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/01/26.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
import AVKit

class FMPhotoPresenterViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var selectedContainer: UIView!
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var selectedIndex: UILabel!
    @IBOutlet weak var determineButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var transparentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unsafeAreaBottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unsafeAreaBottomView: UIView!
    
    // MARK: - Public
    public var swipeInteractionController: FMPhotoInteractionAnimator?
    
    public var didSelectPhotoHandler: ((Int) -> Void)?
    
    public var didDeselectPhotoHandler: ((Int) -> Void)?
    
    public var didMoveToViewControllerHandler: ((FMPhotoViewController, Int) -> Void)?
    
    public var didTapDetermine: (() -> Void)?
    
    public var bottomView: FMPresenterBottomView!
    
    public var isFromEditBtn: Bool = false
    
    public var fileName: String = ""
    
    // MARK: - Private
    private(set) var pageViewController: UIPageViewController!
    
    private var interactiveDismissal: Bool = false
    
    private var currentPhotoIndex: Int
    
    private var dataSource: FMPhotosDataSource
    
    private var config: FMPhotoPickerConfig
    
    private var bottomViewBottomConstraint: NSLayoutConstraint!
    
    private var currentPhotoViewController: FMPhotoViewController? {
        return pageViewController.viewControllers?.first as? FMPhotoViewController
    }
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = config.strings["present_title_photo_created_date_format"]
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(config: FMPhotoPickerConfig, dataSource: FMPhotosDataSource, initialPhotoIndex: Int) {
        self.config = config
        self.dataSource = dataSource
        self.currentPhotoIndex = initialPhotoIndex
        
        super.init(nibName: "FMPhotoPresenterViewController", bundle: Bundle(for: FMPhotoPresenterViewController.self))
        self.setupPageViewController(withInitialPhoto: self.dataSource.photo(atIndex: self.currentPhotoIndex))
    }
    
    private func setupPageViewController(withInitialPhoto initialPhoto: FMPhotoAsset? = nil) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                       navigationOrientation: .horizontal,
                                                       options: [UIPageViewController.OptionsKey.interPageSpacing: 16.0])
        self.pageViewController.view.frame = self.view.frame
        self.pageViewController.view.backgroundColor = .clear
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        if let photo = initialPhoto {
            self.changeToPhoto(photo: photo)
        } else if let photo = self.dataSource.photo(atIndex: 0) {
            self.changeToPhoto(photo: photo)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedContainer.layer.cornerRadius = self.selectedContainer.frame.size.width / 2
        
        self.updateInfoBar()
        
        self.addChild(self.pageViewController)
        self.view.addSubview(pageViewController.view)
        self.view.sendSubviewToBack(pageViewController.view)
        
        
        // Init bottom view
        self.bottomView = FMPresenterBottomView(config: config)
        swipeInteractionController = FMPhotoInteractionAnimator(viewController: self)
        
        self.bottomView.onTapEditButton = { [unowned self] in
            guard let photo = self.dataSource.photo(atIndex: self.currentPhotoIndex),
                  let vc = self.pageViewController.viewControllers?.first as? FMPhotoViewController,
                  let originalThumb = photo.editedThumb,
                  let originalImage = vc.getOriginImage()
            else { return }
            
            let editorVC = FMImageEditorViewController(config: self.config,
                                                       fmPhotoAsset: photo,
                                                       originalImage: originalImage,
                                                       originalThumb: originalThumb)
            editorVC.didEndEditting = { [unowned self] viewDidUpdate in
                if let photoVC = self.pageViewController.viewControllers?.first as? FMPhotoViewController {
                    photoVC.forPresent = true
                    photoVC.reloadPresentImg(complete: viewDidUpdate)
                    photoVC.forPresent = false
                }
            }
            editorVC.modalPresentationStyle = .fullScreen
            self.present(editorVC, animated: false, completion: nil)
        }
        
        self.view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (bottom) in
            bottom.left.equalTo(self.view)
            bottom.right.equalTo(self.view)
            bottom.height.equalTo(90)
        }
        bottomViewBottomConstraint = self.bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomViewBottomConstraint.isActive = true
        
        self.pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.pageViewController.didMove(toParent: self)
        
        self.view.backgroundColor = kBackgroundColor
        
        selectedContainer.isHidden = config.selectMode == .single ? true : config.photoMode
        determineButton.isHidden = config.selectMode == .single ? false : !config.photoMode
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // update bottom view for the first page that can not handled by PageViewControllerDelegate
        self.updateBottomView()
    }
    
    override func viewDidLayoutSubviews() {
        
        transparentViewHeightConstraint.constant = view.safeAreaInsets.top + 44 // 44 is the height of nav bar
        bottomViewBottomConstraint.constant = -view.safeAreaInsets.bottom
        
        unsafeAreaBottomViewHeightConstraint.constant = view.safeAreaInsets.bottom
        unsafeAreaBottomView.backgroundColor = .white
        unsafeAreaBottomView.alpha = 0.9
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Dprint("didReceiveMemoryWarning")
    }
    
    // MARK: - Update Views
    private func updateInfoBar() {
        let n = dataSource.numberOfSelectedPhoto()
        
        if self.config.selectMode == .multiple, n > 0 {
            if n == 1 { self.photoTitle.isHidden = true }
        }
        
        determineButton.isHidden = config.selectMode == .single ? false : !(n > 0)
        
        // Update selection status
        if let selectIdx = self.dataSource.selectedIndexOfPhoto(atIndex: self.currentPhotoIndex + 1) {
            if self.config.selectMode == .multiple {
                self.selectedIndex.isHidden = false
                self.selectedIndex.text = "\(selectIdx + 1)"
                
                let tintedImage = UIImage(named: "check_on")?.withRenderingMode(.alwaysTemplate)
                self.selectedIcon.image = tintedImage
                self.selectedIcon.tintColor = .mainColor
            }
        } else {
            self.selectedIndex.isHidden = true
            self.selectedIcon.image = UIImage(named: "check_off")
        }
        
        // Update photo title
        if let photoAsset = self.dataSource.photo(atIndex: self.currentPhotoIndex),
           let _ = photoAsset.asset?.creationDate,
           let selectedIndex = self.dataSource.selectedIndexOfPhoto(atIndex: self.currentPhotoIndex + 1),
           self.config.selectMode == .multiple {
            
            let n = dataSource.numberOfSelectedPhoto()
            if selectedIndex + 1 > 0 { self.photoTitle.text = "\(selectedIndex + 1) / \(n)" }
            
        }
    }
    
    private func changeToPhoto(photo: FMPhotoAsset) {
        let photoViewController = initializaPhotoViewController(forPhoto: photo)
        self.pageViewController.setViewControllers([photoViewController], direction: .forward, animated: true, completion: nil)
        
        self.updateInfoBar()
    }
    
    private func initializaPhotoViewController(forPhoto photo: FMPhotoAsset) -> FMPhotoViewController {
        let imageViewController = FMImageViewController(withPhoto: photo, config: self.config)
        imageViewController.dataSource = self.dataSource
        return imageViewController
    }
    
    private func updateBottomView() {
        bottomView.imageMode()
    }
    
    // MARK: - Target Actions
    @IBAction func onTapClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onTapSelection(_ sender: Any) {
        
        let curPhotoIdx = currentPhotoIndex + 1
        if self.dataSource.selectedIndexOfPhoto(atIndex: curPhotoIdx) == nil {
            self.didSelectPhotoHandler?(curPhotoIdx)
        } else {
            self.didDeselectPhotoHandler?(curPhotoIdx)
        }
        self.updateInfoBar()
    }
    
    @IBAction func onTapDetermine(_ sender: Any) {
        if config.selectMode == .single { self.didSelectPhotoHandler?(self.currentPhotoIndex) }
        didTapDetermine?()
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIPageViewControllerDataSource / UIPageViewControllerDelegate
extension FMPhotoPresenterViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? FMPhotoViewController,
              let photoIndex = self.dataSource.index(ofPhoto: photoViewController.photo),
              let newPhoto = self.dataSource.photo(atIndex: photoIndex - 1)
        else { return nil }
        
        // edit버튼으로 부터 접근 시 index 처리
        if self.isFromEditBtn {
            
            var selected: [Int] = []
            self.dataSource.getSelectedPhotosIndex().forEach {
                selected.append($0 - 1)
            }
            
            guard let nowIndex:Int = selected.firstIndex(of: photoIndex),
                  selected.contains(photoIndex)
            else { return nil }
            
            let nextIndex: Int = nowIndex - 1
            if nextIndex < selected.count {
                if nextIndex < 0 { 
                    return nil
                } else {
                    guard let nextPhoto = self.dataSource.photo(atIndex: selected[nextIndex]) else { return nil }
                    return self.initializaPhotoViewController(forPhoto: nextPhoto)
                }
            }else { return nil }
        }else {
            return self.config.photoMode ? nil : self.initializaPhotoViewController(forPhoto: newPhoto)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? FMPhotoViewController,
              let photoIndex = self.dataSource.index(ofPhoto: photoViewController.photo),
              let newPhoto = self.dataSource.photo(atIndex: photoIndex + 1) else { return nil }
        
        // edit버튼으로 부터 접근 시 index 처리
        if self.isFromEditBtn {
            
            var selected: [Int] = []
            self.dataSource.getSelectedPhotosIndex().forEach {
                selected.append($0 - 1)
            }
            
            guard let nowIndex:Int = selected.firstIndex(of: photoIndex),
                  selected.contains(photoIndex)
            else { return nil }
            
            let nextIndex: Int = nowIndex + 1
            if nextIndex < selected.count {
                guard let nextPhoto = self.dataSource.photo(atIndex: selected[nextIndex]) else { return nil }
                return self.initializaPhotoViewController(forPhoto: nextPhoto)
                
            }else { return nil }
        }else {
            return self.config.photoMode ? nil : self.initializaPhotoViewController(forPhoto: newPhoto)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let vc = pageViewController.viewControllers?.first as? FMPhotoViewController,
              let photoIndex = self.dataSource.index(ofPhoto: vc.photo)
        else { return }
        
        self.currentPhotoIndex = photoIndex
        self.updateInfoBar()
        self.didMoveToViewControllerHandler?(vc, photoIndex)
        self.updateBottomView()
        previousViewControllers.forEach { vc in
            guard let photoViewController = vc as? FMPhotoViewController else { return }
            photoViewController.photo.cancelAllRequest()
        }
    }
}
