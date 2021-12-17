//
//  Helper.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/01/23.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

typealias deliveryMode = PHImageRequestOptionsDeliveryMode

class HelperPhoto: NSObject {
    
    static var basicCellSize: CGFloat {     // 셀 기본 화질
        get {
            return UIScreen.main.bounds.width / 3 * UIScreen.main.scale
        }
    }
    
    static var cellMaxSize: CGFloat {       // 셀 고화질
        get {
            return UIScreen.main.bounds.width / 2 * UIScreen.main.scale
        }
    }
    
    static var minimumCellSize: CGFloat {   // 셀 저화질
        get {
            return UIScreen.main.bounds.size.width / 4 * UIScreen.main.scale
        }
    }
    
    static func getFullSizePhoto(by asset: PHAsset, complete: @escaping (UIImage?) -> Void) -> PHImageRequestID {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let pId = manager.requestImageData(for: asset, options: options) { data, _, _, info in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return complete(nil)
            }
            complete(image)
        }
        
        return pId
    }
    
    static func getPhoto(by photoAsset: PHAsset, in desireSize: CGSize, with mode: deliveryMode = .opportunistic, complete: @escaping (UIImage?) -> Void) -> PHImageRequestID {
        let options = PHImageRequestOptions()
        options.deliveryMode = mode
        options.resizeMode = .fast
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let manager = PHImageManager.default()
        let newSize = CGSize(width: desireSize.width,
                             height: desireSize.height)
        
        let pId = manager.requestImage(for: photoAsset, targetSize: newSize, contentMode: .aspectFit, options: options, resultHandler: { result, _ in
            
            complete(result)
        })
        
        return pId
    }
    
    static func getAssets() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared, .typeiTunesSynced]
        
        // Default sort is modificationDate
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        guard fetchResult.count > 0 else { return [] }
        
        var photoAssets = [PHAsset]()
        fetchResult.enumerateObjects() { asset, index, _ in
            photoAssets.append(asset)
        }
        
        return photoAssets
    }
    
    static func canAccessPhotoLib() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    static func requestAuthorizationForPhotoAccess(authorized: @escaping () -> Void, rejected: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    authorized()
                } else {
                    rejected()
                }
            }
        }
    }
    
    static func moveToSettingForPhotoAccess(onVc vc: UIViewController) {
        RadAlertViewController.alertControllerShow(WithTitle: RadMessage.title,
                                                   message: RadMessage.Permission.reqLibraryAuth,
                                                   isNeedCancel: true,
                                                   viewController: vc) { isCheck in
            if isCheck { RadHelper.openIphoneSetting() }
        }
    }
}
