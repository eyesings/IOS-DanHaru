//
//  FMCropMenuView.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/03/05.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit

class FMCropMenuView: UIView {
    private let collectionView: UICollectionView
    private let cropItems: [FMCroppable]
    
    public var didSelectCrop: (FMCroppable) -> Void = { _ in }
    
    private var selectedCrop: FMCroppable? {
        didSet {
            if let selectedCrop = selectedCrop {
                didSelectCrop(selectedCrop)
            }
        }
    }
    
    private var config: FMPhotoPickerConfig
    
    init(appliedCrop: FMCroppable?, availableCrops: [FMCroppable], config: FMPhotoPickerConfig) {
        selectedCrop = appliedCrop
        self.config = config
        
        var tAvailableCrops = availableCrops
        tAvailableCrops = tAvailableCrops.count == 0 ? kDefaultAvailableCrops : tAvailableCrops
        
        cropItems = tAvailableCrops
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 64)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: .zero)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (view) in
            view.top.bottom.centerX.equalTo(self)
            view.width.equalTo(self).multipliedBy(0.5)
        }
        
        collectionView.register(FMCropCell.classForCoder(), forCellWithReuseIdentifier: FMCropCell.reussId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    
        self.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
    }
    
    func insert(toView parentView: UIView) {
        parentView.addSubview(self)
        
        self.snp.makeConstraints { (cropMenu) in
            cropMenu.left.right.bottom.top.equalTo(parentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FMCropMenuView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cropItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FMCropCell.reussId, for: indexPath) as? FMCropCell
            else { return UICollectionViewCell() }
        
        // crop items
        let cropItem = cropItems[indexPath.row]
        cell.imageView.image = cropItem.icon()
        
        if selectedCrop?.identifier() == cropItem.identifier() {
            cell.setSelected()
        }
        
        return cell
    }
}
extension FMCropMenuView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? FMCropCell {
            let prevCropItem = selectedCrop
            selectedCrop = cropItems[indexPath.row]
            cell.setSelected()
            
            // 에디터에서 자동으로 1:1 자르기 영역으로
            if let prevCropItem = prevCropItem{
                if let prevRow = cropItems.firstIndex(where: { $0.identifier() == prevCropItem.identifier() }){
                    collectionView.reloadItems(at: [IndexPath(row: prevRow, section: 0)])
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }

}
