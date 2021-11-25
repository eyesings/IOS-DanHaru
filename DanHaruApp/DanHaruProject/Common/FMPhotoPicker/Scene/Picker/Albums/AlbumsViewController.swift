//
//  AlbumsViewController.swift
//  KidiKidCommunity
//
//  Created by RadCns_KIM_TAEWON on 2020/07/17.
//  Copyright © 2020 RadCns_KIM_TAEWON. All rights reserved.
//

import UIKit
import Photos



class AlbumsViewController: UIViewController {
    
    @IBOutlet var dimmedBtn: UIButton!
    @IBOutlet var controlBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var albumList:[AlbumModel] = [AlbumModel]()
    var albumImage: Array<UIImage> = Array()
    
    public var albumDelegate: PhotoAlbumsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: AlbumsTableViewCell.reusableIdentifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "AlbumCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        controlBar.roundCorner(corners: [.topLeft, .topRight], radius: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        UIView.animate(withDuration: 0.2, delay: 0.25) {
            self.dimmedBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    public init(module: [AlbumModel]) {
        Dprint("AlbumsViewController_INIT")
        super.init(nibName: "AlbumsViewController", bundle: Bundle(for: AlbumsViewController.self))
        
        self.albumList = module
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func onTapDimmedBtn(_ sender: UIButton) {
        dismissViewController()
    }
    
}

// MARK: Function
extension AlbumsViewController {
    private func dismissViewController() {
        UIView.animate(withDuration: 0.1) {
            self.dimmedBtn.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AlbumsViewController: UITableViewDelegate {
    
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumsTableViewCell
        
        cell.cellImage.image = self.albumImage[indexPath.row]
        cell.cellLabel.text = self.albumList[indexPath.row].name
        cell.cellCount.text = "(\(self.albumList[indexPath.row].count))"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let albumName = self.albumList[indexPath.row].name
        var photoLibraryImages = [UIImage]()
        var photoLibraryAssets = [PHAsset]()
        
        
        DispatchQueue.global(qos: .userInteractive).sync
        {
            let Customalbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            let SmartAlbumPanoramas = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: nil)
            let SmartAlbumFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
            let SmartAlbumSelfPortraits = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil)
            let SmartAlbumScreenshots = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
            let SmartAlbumBursts = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumBursts, options: nil)
            let SmartAlbumRecentlyAdded = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
            let Cmeraroll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            
            [Cmeraroll, SmartAlbumRecentlyAdded, SmartAlbumSelfPortraits, SmartAlbumFavorites, SmartAlbumBursts, SmartAlbumPanoramas, SmartAlbumScreenshots, Customalbums].forEach {
                $0.enumerateObjects { collection, index, stop in
                    
                    let imgManager = PHImageManager.default()
                    
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.isSynchronous = true
                    requestOptions.deliveryMode = .highQualityFormat
                    
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                    
                    let photoInAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                    
                    if let title = collection.localizedTitle, title == albumName && photoInAlbum.count > 0
                    {
                        for i in (0..<photoInAlbum.count).reversed()
                        {
                            imgManager.requestImage(for: photoInAlbum.object(at: i) as PHAsset,
                                                       targetSize: CGSize(width: 150, height: 150),
                                                       contentMode: .aspectFit,
                                                       options: requestOptions) {
                                
                                guard let img = $0 else { return }
                                photoLibraryImages.append(img)
                                photoLibraryAssets.append(photoInAlbum.object(at: i))
                                
                                if $1 != nil { }
                            }
                        }
                    }
                }
            }
        }
        self.albumDelegate?.albumPhotoAsset(photoLibraryAssets, title: albumName )
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
