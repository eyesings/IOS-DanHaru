//
//  MyChallengeListViewController.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/11/03.
//

import UIKit
import SkeletonView


class MyChallengeListViewController: UIViewController {
    
    @IBOutlet var customSegment: CustomSegmentedControl!
    @IBOutlet var needUpdateUIComponentList: [Any]!
    
    @IBOutlet var collectionviewList: [UICollectionView]!
    @IBOutlet var collectCntLabelList: [UILabel]!
    @IBOutlet var labelSkeletonList: [UIView]!
    
    
    private var challengeCollectVM: ChallengeCollectViewModel = ChallengeCollectViewModel()
    private var collectionviewCategory: MyChallangeBtnTag = .todoList
    private var dataInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customSegment.delegate = self
        
        initLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if RadHelper.isIphoneSE1st {
            
            for view in needUpdateUIComponentList {
                if let layout = view as? NSLayoutConstraint {
                    layout.constant = -10
                } else if let label = view as? UILabel {
                    label.font = .systemFont(ofSize: 18.0, weight: .heavy)
                }
            }
        }
        
        challengeCollectVM = ChallengeCollectViewModel.init()
    }
    
    // MARK: - OBJC Method
    @IBAction func onTapCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func panEdgeSwipeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController()
        }
    }
}

// MARK: - UI Init
extension MyChallengeListViewController {
    private func initLayout() {
        initCollectionSkeletonView()
        showLabelSkeletonView()
        initCollectCount()
        
    }
    
    private func initCollectionSkeletonView() {
        collectionviewList.forEach {
            $0.showAnimatedGradientSkeleton()
            removeViewSkeleton($0)
        }
    }
    
    private func showLabelSkeletonView() {
        labelSkeletonList.forEach {
            $0.showAnimatedGradientSkeleton()
            removeViewSkeleton($0)
        }
    }
    
    private func initCollectCount() {
        for label in collectCntLabelList {
            if let dataType = CollectionViewTag.init(rawValue: label.tag) {
                let cntText = String(format: "%02d", self.getCollectModel(by: dataType).count)
                label.text = cntText
            }
        }
    }
    
    private func removeViewSkeleton(_ view: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            view.hideSkeleton()
        }
    }
    
    private func createNoneDataInfoView(on view: UICollectionView, _ type: CollectionViewTag) {
        
        let cateTypeText: String = {
            return self.collectionviewCategory == .myChallange ? "도전" : "할 일"
        }()
        
        dataInfoLabel = UILabel(frame: view.frame)
        dataInfoLabel.backgroundColor = .backgroundColor
        dataInfoLabel.text = "\(type.name()) \(cateTypeText)이 없습니다."
        dataInfoLabel.font = .systemFont(ofSize: 18.0)
        dataInfoLabel.textColor = .customBlackColor
        dataInfoLabel.textAlignment = .center
        self.view.addSubview(dataInfoLabel)
    }
}

// MARK: - CustomSegment Delegate
extension MyChallengeListViewController: CustomSegmentedControlDelegate {
    func SegmentChanged(_ sender: UIButton) {
        guard let challangeCate = MyChallangeBtnTag.init(rawValue: sender.tag),
              self.collectionviewCategory != challangeCate else { return }
        
        self.collectionviewCategory = challangeCate
        collectionviewList.forEach { collection in
            dataInfoLabel?.removeFromSuperview()
            self.initCollectCount()
            collection.reloadData()
            collection.performBatchUpdates {
                let cnt = collection.numberOfItems(inSection: 0)
                guard let type = CollectionViewTag.init(rawValue: collection.tag) else { return }
                if cnt == 0 {
                    DispatchQueue.main.async {
                        self.createNoneDataInfoView(on: collection, type)
                    }
                }
            }
        }
    }
    
    
}


extension MyChallengeListViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        guard let collectionViewTag = CollectionViewTag.init(rawValue: skeletonView.tag) else { return "" }
        return CollectionViewID.getIdByTag(collectionViewTag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let collectionViewTag = CollectionViewTag.init(rawValue: collectionView.tag) else { return 0 }
        return getCollectModel(by: collectionViewTag).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if RadHelper.isIphoneSE1st,
           let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 10, right: 30)
        }
        
        guard let collectionViewTag = CollectionViewTag.init(rawValue: collectionView.tag),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewID.getIdByTag(collectionViewTag), for: indexPath) as? MyChallengeCell else { return UICollectionViewCell() }
        
        let modelList = getCollectModel(by: collectionViewTag)
        for (idx, model) in modelList.enumerated() {
            if idx == indexPath.item {
                cell.cellTitle.text = model.title
            }
        }
        
        return cell
    }
    
    private func getCollectModel(by collectType: CollectionViewTag) -> [TodoCollectModel] {
        let collectModel = challengeCollectVM.model
        var modelList: [TodoCollectModel] = []
        
        for model in collectModel {
            if model.modelStateType == collectType && model.modelCategory == self.collectionviewCategory { modelList.append(model) }
        }
        
        return modelList
    }
}

extension MyChallengeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = RadHelper.isIphoneSE1st ? screenwidth * 0.28 : screenwidth * 0.3
        return CGSize(width: size * 1.1, height: size)
    }
}
