//
//  AlbumsModel.swift
//  KidiKidCommunity
//
//  Created by RadCns_KIM_TAEWON on 2020/07/17.
//  Copyright © 2020 RadCns_KIM_TAEWON. All rights reserved.
//

import Foundation
import Photos

class AlbumModel {
    let name:String
    let count:Int
    let collection:PHAssetCollection
    init(name:String, count:Int, collection:PHAssetCollection) {
        self.name = name
        self.count = count
        self.collection = collection
    }
}
