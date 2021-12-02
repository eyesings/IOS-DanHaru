//
//  Protocols.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/15/17.
//
//

import Foundation
import UIKit
import Photos


/// 앨범 Asset  protocol
public protocol PhotoAlbumsDelegate {
    func albumPhotoAsset(_ albumAsset: [PHAsset], title:String)
}
/**
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 */

public protocol PhotoEditorDelegate {
    /**
     - Parameter image: edited Image
     */
    func doneEditing(image: UIImage)
    func canceledEditing()
}

@objc protocol keyboardNotiRegistProtocol: NSObjectProtocol {
    func keyboardShowAndHide(_ notification: Notification)
}

extension keyboardNotiRegistProtocol {
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowAndHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowAndHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        keyboardH = 0.0
    }
}
