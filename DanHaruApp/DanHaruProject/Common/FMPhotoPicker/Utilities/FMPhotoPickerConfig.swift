//
//  FMPhotoPickerOptions.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/09.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import Foundation
import Photos

public enum FMSelectMode {
    case multiple
    case single
}



public enum FMMediaType {
    case image
    case unsupported
    
    public func value() -> Int {
        switch self {
        case .image:
            return PHAssetMediaType.image.rawValue
        case .unsupported:
            return PHAssetMediaType.unknown.rawValue
        }
    }
    
    init(withPHAssetMediaType type: PHAssetMediaType) {
        switch type {
        case .image:
            self = .image
        default:
            self = .unsupported
        }
    }
}

public struct FMPhotoPickerConfig {
    public var selectMode: FMSelectMode = .multiple
    public var maxImage: Int = 3
    public var photoMode: Bool = false
    public var availableCrops: [FMCroppable] = kDefaultAvailableCrops
    
    public var eclipsePreviewEnabled = false
    
    public var strings: [String: String] = [
        "picker_warning_over_image_select_format":  "사진은 최대 %d개까지 첨부 가능합니다.",
        
        "present_title_photo_created_date_format":  "yyyy/M/d",
        "present_button_edit_image":                "이미지 편집"
    ]
    
    public init() {
        
    }
}
