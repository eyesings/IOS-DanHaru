//
//  FMPhotoAsset.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/01/25.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
import Photos

public class FMPhotoAsset {
    let asset: PHAsset?
    let sourceImage: UIImage?
    
    var mediaType: FMMediaType
    
    // a fully edited thumbnail version of the image
    var editedThumb: UIImage?
    
    var originalImageSize: CGSize?
    
    var thumbRequestId: PHImageRequestID?
    
    var thumbChanged: (UIImage) -> Void = { _ in }
    
    var editedImage: UIImage?
    
    private var fullSizePhotoRequestId: PHImageRequestID?
    private var editor: FMImageEditor!
    
    private var canceledFullSizeRequest = false
    
    init(asset: PHAsset) {
        self.asset = asset
        self.mediaType = FMMediaType(withPHAssetMediaType: asset.mediaType)
        self.sourceImage = nil
        
        self.editor = FMImageEditor()
    }
    
    init(sourceImage: UIImage) {
        self.sourceImage = sourceImage
        self.mediaType = .image
        self.asset = nil
        
        self.editor = FMImageEditor()
    }
    
    
    func requestThumb(refresh: Bool=false, desireSize: CGFloat = HelperPhoto.minimumCellSize, _ mode:deliveryMode = .opportunistic , _ complete: @escaping (UIImage?) -> Void) {
        if let editedThumb = self.editedThumb, !refresh {
            complete(editedThumb)
        } else {
            // It is not absolutely right but it gives much better performance in most cases
            let cropScale = (editor.cropArea.scaleW + editor.cropArea.scaleH) / 2
            let size = CGSize(width: desireSize / cropScale, height: desireSize / cropScale)
            if let asset = asset {
                //thumbImage
                self.thumbRequestId = HelperPhoto.getPhoto(by: asset, in: size, with: mode) { image in
                    self.thumbRequestId = nil
                    
                    guard let image = image else { complete(nil); return }
                    
                    self.editedThumb    = self.editor.reproduce(source: image, cropState: .edited)
                    
                    DispatchQueue.main.async {
                        complete(self.editedThumb)
                    }
                    
                }
            } else {
                guard let image = sourceImage else { return complete(nil) }
                let edited = self.editor.reproduce(source: image.resize(toSizeInPixel: size), cropState: .edited)
                complete(edited)
            }
        }
    }
    
    func requestImage(in desireSize: CGSize, _ complete: @escaping (UIImage?) -> Void) {
        if let asset = asset {
            _ = HelperPhoto.getPhoto(by: asset, in: desireSize) { image in
                guard let image = image else { return complete(nil) }
                let edited = self.editor.reproduce(source: image, cropState: .edited)
                complete(edited)
            }
        } else {
            guard let image = sourceImage?.resize(toSizeInPixel: desireSize) else { return complete(nil) }
            let edited = self.editor.reproduce(source: image, cropState: .edited)
            complete(edited)
        }
    }
    
    func requestFullSizePhoto(cropState: FMImageEditState, complete: @escaping (UIImage?) -> Void) {
        if let asset = asset {
            self.fullSizePhotoRequestId = HelperPhoto.getPhoto(by: asset, in: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), with: .highQualityFormat){ image in
                self.fullSizePhotoRequestId = nil
                if self.canceledFullSizeRequest {
                    self.canceledFullSizeRequest = false
                    complete(nil)
                } else {
                    guard let image = image else { return complete(nil) }
                    // 스티커 유무에 따른 처리
                    // forThumbnail = ture 이면 스티커 까지 붙인 이미지 반환, false 이면 사진만 반환(스티커 적용x)
                    let result = self.editor.reproduce(source: image, cropState: cropState)
                    if cropState == .edited { self.editedImage = result }       // crop 이벤트 있을 때 해당 결과의 이미지 저장
                    complete(result)
                }
            }
        } else {
            guard let image = sourceImage else { return complete(nil) }
            let result = self.editor.reproduce(source: image, cropState: cropState)
            complete(result)
        }
    }
    
    // 원본 이미지 사이즈 set
    func setImageSize(_ size: CGSize) {
        self.originalImageSize = size
    }
    
    // 원본 이미지 사이즈 get
    func getImageSize() -> CGSize? {
        if let size = self.originalImageSize {
            return size
        }else {
            return nil
        }
    }
    
    // MARK: - Editor
    
    public func cancelAllRequest() {
        self.cancelThumbRequest()
        self.cancelFullSizePhotoRequest()
    }
    
    public func cancelThumbRequest() {
        if let thumbRequestId = self.thumbRequestId {
            PHImageManager.default().cancelImageRequest(thumbRequestId)
        }
    }
    
    public func cancelFullSizePhotoRequest() {
        if let fullSizePhotoRequestId = self.fullSizePhotoRequestId {
            PHImageManager.default().cancelImageRequest(fullSizePhotoRequestId)
            self.canceledFullSizeRequest = true
        }
    }
    
    public func getAppliedCrop() -> FMCroppable {
        return editor.crop
    }
    
    public func getAppliedCropArea() -> FMCropArea {
        return editor.cropArea
    }
    
    public func apply(crop: FMCroppable, cropArea: FMCropArea) {
        editor.crop = crop
        editor.cropArea = cropArea
        
        requestThumb(refresh: true) { image in
            if let image = image {
                self.thumbChanged(image)
            }
        }
    }
    
    public func isEdited() -> Bool {
        return editor.isEdited()
    }
}
