//
//  FMPhotoPickerImageCollectionViewCell.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/01/23.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
import Photos

class FMPhotoPickerImageCollectionViewCell: UICollectionViewCell {
    static let scale: CGFloat = 3
    static let reuseId = String(describing: FMPhotoPickerImageCollectionViewCell.self)
    
    
    @IBOutlet weak var cellFilterContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectIdxLabel: UILabel!
    
    private weak var photoAsset: FMPhotoAsset?
    
    public var onTapSelect = {}
    
    private var selectMode: FMSelectMode!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellFilterContainer.isHidden = true
        self.cellFilterContainer.layer.borderColor = UIColor.mainColor.cgColor
        self.selectIdxLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
        
        self.photoAsset?.cancelAllRequest()
    }
    
    public func loadView(photoAsset: FMPhotoAsset, selectMode: FMSelectMode, selectedIndex: Int?) {
        self.selectMode = selectMode
        
        self.selectButton.isHidden = selectMode == .single
        
        self.photoAsset = photoAsset

        photoAsset.requestThumb() { image in
            DispatchQueue.main.async {
                self.imageView.image = image?.cropToBounds()
            }
        }
        
        photoAsset.thumbChanged = { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.imageView.image = image
        }
        
        self.performSelectionAnimation(selectedIndex: selectedIndex)
    }
    
    @IBAction func onTapSelects(_ sender: Any) {
        self.onTapSelect()
    }
    
    func performSelectionAnimation(selectedIndex: Int?) {
        if let selectedIdx = selectedIndex {
            if self.selectMode == .multiple {
                self.cellFilterContainer.layer.borderWidth = 4.0
                
                let tintedImage = UIImage(named: "check_on")?.withRenderingMode(.alwaysTemplate)
                self.selectButton.setImage(tintedImage, for: .normal)
                self.selectButton.imageView?.tintColor = .mainColor
                
                self.selectIdxLabel.text = "\(selectedIdx + 1)"
            }
        } else {
            self.cellFilterContainer.layer.borderWidth = 0.0
            self.selectButton.setImage(UIImage(named: "check_off"), for: .normal)
        }
        
        self.cellFilterContainer.isHidden = self.selectMode == .multiple
        self.selectIdxLabel.isHidden = self.selectMode == .single
    }
}
