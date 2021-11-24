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
    
    // the full size image that is applied filter
    private var filteredImage: UIImage
    
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
    public init(config: FMPhotoPickerConfig, fmPhotoAsset: FMPhotoAsset, filteredImage: UIImage, originalThumb: UIImage) {
        self.config = config
        
        self.fmPhotoAsset = fmPhotoAsset
        
        self.originalThumb = originalThumb
        
        // set to filteredImage until the load original image done
        self.originalImage = filteredImage
        
        self.filteredImage = filteredImage
        
        selectedCrop = fmPhotoAsset.getAppliedCrop()
        
        isAnimatedPresent = false
        
        super.init(nibName: "FMImageEditorViewController", bundle: Bundle(for: FMImageEditorViewController.self))
        
        self.view.backgroundColor = kBackgroundColor
    }
    
    public init(config: FMPhotoPickerConfig, sourceImage: UIImage) {
        self.config = config
        
        let forceCropType = config.forceCropEnabled ? config.availableCrops.first! : nil
        let fmPhotoAsset = FMPhotoAsset(sourceImage: sourceImage, forceCropType: forceCropType)
        self.fmPhotoAsset = fmPhotoAsset
        
        self.originalThumb = sourceImage
        
        self.originalImage = sourceImage
        self.filteredImage = sourceImage

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
        
        cropView = FMCropView(image: filteredImage,
                              appliedCrop: fmPhotoAsset.getAppliedCrop(),
                              appliedCropArea: fmPhotoAsset.getAppliedCropArea())
        cropView.foregroundView.eclipsePreviewEnabled = self.config.eclipsePreviewEnabled
        
        self.view.addSubview(self.cropView)
        self.view.sendSubviewToBack(self.cropView)
        
        DispatchQueue.main.async {
            
            
            self.cropSubMenuView.insert(toView: self.subMenuContainer)
            
            // get full size original image without any crop or filter applied
            self.fmPhotoAsset.requestFullSizePhoto(cropState: .original, filterState: .original) { [weak self] image in
                guard let strongSelf = self,
                    let image = image else { return }
                strongSelf.originalImage = image
                strongSelf.cropView.foregroundView.compareView.image = image
            }
        }
        
        if !isAnimatedPresent {
            // Hide entire view view until the crop view image is located
            // Because the crop view's frame is restore when view did appear
            // It's neccssary to hide the initial view until the view's position restore is completed
            // It will make the transition become more natural and smooth
            view.isHidden = true
        }
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide top and bottom menu
        bottomMenuBottomConstraint.constant = -bottomMenuContainer.frame.height
        topMenuTopConstraint.constant = -topMenuContainter.frame.height
        
        // show filter mode by default
        // hide the crop corners before it is shown
        // dissable pan and pinch has no effect at this time
        // so we need call again in viewDidAppear to dissable them
        cropView.isCropping = false
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
        
        // crop 메뉴 미 선택시 (==ratioCustom) 기본 1x1로 상태 변경
        if selectedCrop.identifier() == "ratioCustom" {
            selectedCrop = FMCrop.ratioSquare
        }
        
        cropView.moveCropBoxToAspectFillContentFrame() {
            // get crop data:
            let cropArea = self.cropView.getCropArea()
            
            self.fmPhotoAsset.apply(crop: self.selectedCrop,
                                    cropArea: cropArea)
            
            if let delegate = self.delegate {
                // In case that FMImageEditorViewController is used as standard-alone tool
                self.fmPhotoAsset.requestFullSizePhoto(cropState: .edited, filterState: .edited) { image in
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
        
        self.hideAnimatedMenu() {}
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
        UIView.animate(withDuration: kEnteringAnimationDuration,
                       animations: {
                        self.cropSubMenuView.alpha = 1
        },
                       completion: { _ in })
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
                       options: .curveEaseOut,
                       animations: {
                        self.topMenuContainter.alpha = 1
                        self.bottomMenuContainer.alpha = 1
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
        
        self.topMenuTopConstraint.constant = 0
        self.bottomMenuBottomConstraint.constant = 0
    }
    
    private func hideAnimatedMenu(completion: (() -> Void)?) {
        self.topMenuTopConstraint.constant = -self.topMenuContainter.frame.height
        self.bottomMenuBottomConstraint.constant = -self.bottomMenuContainer.frame.height
        UIView.animate(withDuration: kLeavingAnimationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.topMenuContainter.alpha = 0
                        self.bottomMenuContainer.alpha = 0
                        self.subMenuContainer.alpha = 0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        completion?()
        })
    }
    
    private func beforeCrop() {
        if selectedCrop.identifier() == "ratioCustom" {
            cropView.changeRatio = true
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
    
    private func contentFrameSticker() -> CGRect {
        return CGRect(x: 0,
                      y: transparentViewHeightConstraint.constant,
                      width: view.bounds.width,
                      height: view.bounds.height - transparentViewHeightConstraint.constant - bottomMenuContainer.frame.height - subMenuContainer.frame.height - unsafeAreaBottomViewHeightConstraint.constant)
    }
    
    private func contentFrameFullScreen() -> CGRect {
        return view.bounds
    }
    
    // 화면이 작을때..... frame 깨짐 현상 -> 작은 device 인지 가져옴
    private func getDeviceInfo() -> Bool {
        if view.safeAreaInsets.top <= 0 {
            return true
        }
        return false
    }
}

extension UIImage {
    
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: .zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let contenxt = UIGraphicsGetCurrentContext()!
        
        contenxt.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        contenxt.rotate(by: radians)
        
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
