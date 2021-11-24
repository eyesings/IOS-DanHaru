//
//  FMPhotoViewController.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/01/29.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
import Photos

class FMPhotoViewController: UIViewController {
    // MARK: - Public
    public var photo: FMPhotoAsset
    
    public var dataSource: FMPhotosDataSource!
    
    public var config: FMPhotoPickerConfig
    
    public var forPresent: Bool = false         // picker -> present 로 이동시 보여질 이미지
    
    // MARK: - Init
    public init(withPhoto photo: FMPhotoAsset, config: FMPhotoPickerConfig) {
        self.photo = photo
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.photo.cancelAllRequest()
    }
    
    public func viewToSnapshot() -> UIView {
        return self.view
    }
    
    public func displayingImage() -> UIImage? {
        return nil
    }
    
    public func getFilteredImage() -> UIImage? {
        return nil
    }
    
    public func thumbImage() -> UIImage? {
        return nil
    }
    
    public func getOriginImage() -> UIImage? {
        return nil
    }
    
    public func reloadPhoto(complete: @escaping () -> Void) {
        
    }
    
    public func reloadPresentImg(complete: @escaping () -> Void) {
        
    }
}
