//
//  FMCrop.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/09.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

public struct FMCropRatio {
    let width: CGFloat
    let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

public enum FMCrop: FMCroppable {
    case ratio3x4
    case ratio4x3
    case ratioSquare
    
    public func ratio() -> FMCropRatio? {
        switch self {
        case .ratio3x4:
            return FMCropRatio(width: 3, height: 4)
        case .ratio4x3:
            return FMCropRatio(width: 4, height: 3)
        case .ratioSquare:
            return FMCropRatio(width: 1, height: 1)
        }
    }
    
    public func icon() -> UIImage {
        var icon: UIImage?
        switch self {
        case .ratio3x4:
            icon = UIImage(named: "3x4Crop", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratio4x3:
            icon = UIImage(named: "4x3Crop", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        case .ratioSquare:
            icon = UIImage(named: "squreCrop", in: Bundle(for: FMPhotoPickerViewController.self), compatibleWith: nil)
        }
        if icon != nil {
            return icon!
        }
        return UIImage()
    }
    
    public func identifier() -> String {
        switch self {
        case .ratio3x4: return "ratio3x4"
        case .ratio4x3: return "ratio4x3"
        case .ratioSquare: return "ratioSquare"
        }
    }
}
