//
//  FMImageEditorViewController.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/27.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

let kContentFrameSpacing: CGFloat = 22.0

// MARK: - Delegate protocol
public protocol FMImageEditorViewControllerDelegate: AnyObject {
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage)
}

public class FMImageEditorViewController: UIViewController {
    
    
    
    @IBOutlet weak var topMenuTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var transparentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMenuBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topMenuContainter: UIView!
    @IBOutlet weak var bottomMenuContainer: UIView!
    @IBOutlet weak var subMenuContainer: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var unsafeAreaBottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unsafeAreaBottomView: UIView!
    
    
    @IBOutlet weak var cropMenuView: UIView!
    
    
    public var didEndEditting: (@escaping () -> Void) -> Void = { _ in }
    public var delegate: FMImageEditorViewControllerDelegate?
    
    private let isAnimatedPresent: Bool
    
    
    lazy private var cropSubMenuView: FMCropMenuView = {
        let cropSubMenuView = FMCropMenuView(appliedCrop: selectedCrop, availableCrops: config.availableCrops, config: config)
        cropSubMenuView.didSelectCrop = { [unowned self] crop in
            self.selectedCrop = crop
            self.cropView.crop = crop
        }
        return cropSubMenuView
    }()
    
    private var cropView: FMCropView!
    
    public var fmPhotoAsset: FMPhotoAsset
    
    // the original thumbnail image
    // used to preview filters
    private var originalThumb: UIImage
    
    // the original image without any filter or crop
    private var originalImage: UIImage
    
    private var selectedCrop: FMCroppable
    
    private var config: FMPhotoPickerConfig
    
    // MARK: - CUSTOM KTW
    var imageViewToPan: UIImageView?
    var lastPanPoint: CGPoint?
    var resultImageView: UIImageView?
    var resutlView: UIView!
    
    
    
    // MARK: - Init
    public init(config: FMPhotoPickerConfig, fmPhotoAsset: FMPhotoAsset, originalImage: UIImage, originalThumb: UIImage) {
        self.config = config
        
        self.fmPhotoAsset = fmPhotoAsset
        
        self.originalThumb = originalThumb
        self.originalImage = originalImage
        
        selectedCrop = fmPhotoAsset.getAppliedCrop()
        
        isAnimatedPresent = false
        
        super.init(nibName: "FMImageEditorViewController", bundle: Bundle(for: FMImageEditorViewController.self))
        
        self.view.backgroundColor = kBackgroundColor
    }
    
    public init(config: FMPhotoPickerConfig, sourceImage: UIImage) {
        self.config = config
        
        let fmPhotoAsset = FMPhotoAsset(sourceImage: sourceImage)
        self.fmPhotoAsset = fmPhotoAsset
        
        self.originalThumb = sourceImage
        self.originalImage = sourceImage

        selectedCrop = fmPhotoAsset.getAppliedCrop()
        
        isAnimatedPresent = true
        
        super.init(nibName: "FMImageEditorViewController", bundle: Bundle(for: FMImageEditorViewController.self))
        
        fmPhotoAsset.requestThumb { image in
            self.originalThumb = image!
        }
        
        self.view.backgroundColor = kBackgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        topMenuContainter.isHidden = true
        subMenuContainer.isHidden = true
        cropSubMenuView.isHidden = true
        
        cropView = FMCropView(image: originalImage,
                              appliedCrop: fmPhotoAsset.getAppliedCrop(),
                              appliedCropArea: fmPhotoAsset.getAppliedCropArea())
        cropView.foregroundView.eclipsePreviewEnabled = self.config.eclipsePreviewEnabled
        
        self.view.addSubview(self.cropView)
        self.view.sendSubviewToBack(self.cropView)
        
        DispatchQueue.main.async {
            
            
            self.cropSubMenuView.insert(toView: self.subMenuContainer)
            
            // get full size original image without any crop or filter applied
            self.fmPhotoAsset.requestFullSizePhoto(cropState: .original) { [weak self] image in
                guard let strongSelf = self,
                    let image = image else { return }
                strongSelf.originalImage = image
                strongSelf.cropView.foregroundView.compareView.image = image
            }
        }
        
        if !isAnimatedPresent {
            view.isHidden = true
        }
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide top and bottom menu
        bottomMenuBottomConstraint.constant = -bottomMenuContainer.frame.height
        topMenuTopConstraint.constant = -topMenuContainter.frame.height
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // show top menu before animation
        topMenuContainter.isHidden = false
        
        // restore crop image location from previous edditting session
        cropView.contentFrame = contentFrameFullScreen()
        cropView.restoreFromPreviousEdittingSection()
        
        // move image to center of contentFrame
        cropView.contentFrame = contentFrameFilter()
        cropView.moveCropBoxToAspectFillContentFrame()
        cropView.defaultCrop = true //default crop 1:1
        
        // show view the crop view image is re-located
        if !isAnimatedPresent {
            view.isHidden = false
        }
        
        showAnimatedMenu()
        
        cropView.isCropping = true
        openCropMenu()
    }
    
    override public func viewDidLayoutSubviews() {
        cropView.frame = view.frame
        
        transparentViewHeightConstraint.constant = view.safeAreaInsets.top + 44
        
        unsafeAreaBottomViewHeightConstraint.constant = view.safeAreaInsets.bottom
        unsafeAreaBottomView.backgroundColor = .white
        unsafeAreaBottomView.alpha = 0.9
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBActions
    @IBAction func onTapDone(_ sender: Any) {
        cropView.isCropping = false
        
        cropView.moveCropBoxToAspectFillContentFrame() {
            
            let cropArea = self.cropView.getCropArea()
            
            self.fmPhotoAsset.apply(crop: self.selectedCrop,
                                    cropArea: cropArea)
            
            if let delegate = self.delegate {
                // In case that FMImageEditorViewController is used as standard-alone tool
                self.fmPhotoAsset.requestFullSizePhoto(cropState: .edited) { image in
                    if let image = image {
                        delegate.fmImageEditorViewController(self, didFinishEdittingPhotoWith: image)
                    }
                }
            } else {
                // notify PresenterViewController to update it's image
                self.didEndEditting() {
                    self.dismiss(animated: self.isAnimatedPresent)
                }
            }
        }
        
        self.hideAnimatedMenu()
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.cropView.isCropping = false
        
        self.cropView.contentFrame = self.contentFrameFullScreen()
        self.cropView.moveCropBoxToAspectFillContentFrame()
        self.hideAnimatedMenu {
            self.dismiss(animated: self.isAnimatedPresent, completion: nil)
        }
    }
    
    // MARK: - Animation
    private func showAnimatedCropMenu() {
        guard cropSubMenuView.isHidden == true else { return }
        
        subMenuContainer.isHidden = false
        cropSubMenuView.isHidden = false
        
        cropSubMenuView.alpha = 0
        UIView.animate(withDuration: kEnteringAnimationDuration) {
            self.cropSubMenuView.alpha = 1
        }
    }
    
    // crop 메뉴 열기
    private func openCropMenu() {
        
        showAnimatedCropMenu()
        
        cropView.contentFrame = contentFrameCrop()
        cropView.moveCropBoxToAspectFillContentFrame()
        cropView.isCropping = true
        cropView.defaultCrop = true //default crop 1:1
        
        // disable foreground touches to return control to scrollview
        cropView.foregroundView.isEnabledTouches = false
    }
    
    private func showAnimatedMenu() {
        topMenuTopConstraint.constant = topMenuContainter.frame.height
        bottomMenuBottomConstraint.constant = bottomMenuContainer.frame.height
        topMenuContainter.alpha = 0
        bottomMenuContainer.alpha = 0
        UIView.animate(withDuration: kEnteringAnimationDuration,
                       delay: 0,
                       options: .curveEaseOut) {
            self.topMenuContainter.alpha = 1
            self.bottomMenuContainer.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        self.topMenuTopConstraint.constant = 0
        self.bottomMenuBottomConstraint.constant = 0
    }
    
    private func hideAnimatedMenu(completion: (() -> Void)? = nil) {
        self.topMenuTopConstraint.constant = -self.topMenuContainter.frame.height
        self.bottomMenuBottomConstraint.constant = -self.bottomMenuContainer.frame.height
        UIView.animate(withDuration: kLeavingAnimationDuration,
                       delay: 0,
                       options: .curveEaseOut) {
            self.topMenuContainter.alpha = 0
            self.bottomMenuContainer.alpha = 0
            self.subMenuContainer.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }

    }
    
    // MARK: - Logics
    private func contentFrameCrop() -> CGRect {
        let frameWidth: CGFloat = view.bounds.width - 2 * kContentFrameSpacing
        var frameHeight: CGFloat = view.bounds.height
        frameHeight -= transparentViewHeightConstraint.constant
        frameHeight -= bottomMenuContainer.frame.height
        frameHeight -= subMenuContainer.frame.height
        frameHeight -= unsafeAreaBottomViewHeightConstraint.constant
        frameHeight -= 2 * kContentFrameSpacing

        return CGRect(x: kContentFrameSpacing,
                      y: kContentFrameSpacing + transparentViewHeightConstraint.constant,
                      width: frameWidth,
                      height: frameHeight)
    }
    
    private func contentFrameFilter() -> CGRect {
        return CGRect(x: 0,
                      y: transparentViewHeightConstraint.constant,
                      width: view.bounds.width,
                      height: view.bounds.height - transparentViewHeightConstraint.constant - bottomMenuContainer.frame.height - subMenuContainer.frame.height - unsafeAreaBottomViewHeightConstraint.constant)
    }
    
    private func contentFrameFullScreen() -> CGRect {
        return view.bounds
    }
}
