//
//  FMStickerable.swift
//  PhotoLibery
//
//  Created by RadCns_KIM_TAEWON on 2020/03/27.
//  Copyright © 2020 RadCns_KIM_TAEWON. All rights reserved.
//

import UIKit

public protocol FMStickerable {
    func sticker(image: UIImage) -> UIImage
    func stickerName() -> String
}

public enum FMSticker: FMStickerable {
    
    case None
    case Sticks
    
    public func sticker(image: UIImage) -> UIImage {
        return image
    }
    
    public func stickerName() -> String {
        switch self {
        case .None: return "None"
        case .Sticks: return "Sticks"
        }
    }
}

