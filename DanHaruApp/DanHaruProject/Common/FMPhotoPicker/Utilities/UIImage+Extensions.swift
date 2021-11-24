//
//  UIImage+Extensions.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/13.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    func resize(toSizeInPixel: CGSize) -> UIImage {
        let screenScale = UIScreen.main.scale
        let sizeInPoint = CGSize(width: toSizeInPixel.width / screenScale,
                                 height: toSizeInPixel.height / screenScale)
        return resize(toSizeInPoint: sizeInPoint)
    }
    
    
    func resize(toSizeInPoint: CGSize) -> UIImage {
        let size = self.size
        var newImage: UIImage
        
        let widthRatio  = toSizeInPoint.width  / size.width
        let heightRatio = toSizeInPoint.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
    
    /// ratateImage
    /// - Parameter image: UIimage
    /// - Returns: UIimage
    func rotate() -> UIImage {
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// 이미지 리사이징
    /// 1:1 크기로 리사이즈
    func resize() -> UIImage {
        
        var new_image: UIImage!
        var sizeWidth: CGFloat
        var sizeHeight: CGFloat
        
        if self.size.width > self.size.height {
            sizeWidth = self.size.height
            sizeHeight = self.size.height
        } else {
            sizeWidth = self.size.width
            sizeHeight = self.size.width
        }
        
        let size = CGSize(width: sizeWidth, height: sizeHeight)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)
        new_image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return new_image
    }
    
    /// 1:1 자동자르기
    /// - Parameters:
    ///   - width: width description
    ///   - height: height description
    /// - Returns: crop image
    func cropToBounds(width: Double = 2000, height: Double = 2000) -> UIImage {
        
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        let imageWidth = contextSize.width
        let imageheight = contextSize.height
        let imageRatio: Double = Double((imageWidth / imageheight) * 100)
        
        var image: UIImage = self
        
        if floor(imageRatio) == 100 || floor(imageRatio) == 75 || floor(imageRatio) == 133 {
            
        } else {
            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }
            
            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
            
            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!
            
            // Create a new image based on the imageRef and rotate back to the original orientation
            image = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        }
        
        return image
    }
    
}
