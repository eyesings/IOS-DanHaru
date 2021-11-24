//
//  Const.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/04/05.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

internal let kComplexAnimationDuration: Double = 0.375
internal let kEnteringAnimationDuration: Double = 0.225
internal let kLeavingAnimationDuration: Double = 0.195
internal let kKeyframeAnimationDuration: Double = 2.0

internal let kRedColor = UIColor.subHeavyColor
internal let kGrayColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1)
internal let kBackgroundColor = UIColor.backgroundColor
internal let kTransparentBackgroundColor = UIColor(white: 1, alpha: 0.9)
internal let kBorderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)

internal let kDefaultCrop = FMCrop.ratioSquare

internal let kEpsilon: CGFloat = 0.01

internal let kDefaultAvailableCrops = [
    FMCrop.ratioSquare,
    FMCrop.ratio4x3,
    FMCrop.ratio3x4
]
