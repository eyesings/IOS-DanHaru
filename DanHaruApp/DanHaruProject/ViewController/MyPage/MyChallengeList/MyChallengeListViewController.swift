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
    
    
    private var challengeCollectModel: UserTotalModel = UserTotalModel()
    private var collectionviewCategory: MyChallangeBtnTag = .todoList
    
    
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
        showSkeleton()
        
        _ = UserTotalTodoViewModel.init {
            self.challengeCollectModel = $0
            self.removeSkeleton()
        } errorHandler: { Dprint("error \($0)") }
    }
    
    private func showSkeleton() {
        collectionviewList.forEach {
            $0.showAnimatedGradientSkeleton()
        }
        labelSkeletonList.forEach {
            $0.showAnimatedGradientSkeleton()
        }
    }
    
    private func removeSkeleton() {
        collectionviewList.forEach {
            removeViewSkeleton($0)
        }
        labelSkeletonList.forEach {
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
        for collection in collectionviewList {
            if let dataType = CollectionViewTag.init(rawValue: collection.tag), self.getCollectModel(by: dataType).count == 0 {
                self.createNoneDataInfoView(on: collection, dataType)
            }
        }
    }
    
    private func removeViewSkeleton(_ view: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            view.hideSkeleton()
            self.initCollectCount()
        }
    }
    
    private func createNoneDataInfoView(on view: UICollectionView, _ type: CollectionViewTag) {
        let dataInfoLabel = UILabel(frame: view.frame)
        dataInfoLabel.backgroundColor = .backgroundColor
        dataInfoLabel.text = "\(type.name()) \(self.collectionviewCategory.name())이 없습니다."
        dataInfoLabel.font = .systemFont(ofSize: 18.0)
        dataInfoLabel.textColor = .customBlackColor
        dataInfoLabel.textAlignment = .center
        dataInfoLabel.tag = CollectionViewTag.none.rawValue
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
            for view in self.view.subviews {
                if view.tag == CollectionViewTag.none.rawValue { view.removeFromSuperview() }
            }
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
                cell.cellTitle.text = model.encodedTitle
                cell.cellDateLabel.text = model.fr_date?.stringToDate()?.dateToStr(format: "dd.MM.YYYY")
                cell.changeColorByUse(model.use_yn?.lowercased() == "n")
            }
        }
        
        return cell
    }
    
    private func getCollectModel(by collectType: CollectionViewTag) -> [TodoModel] {
        var modelList: [TodoModel] = []

        func setModelForCollection(_ todoModel: [TodoModel], _ challModel: [TodoModel]) {
            let sortModel = (self.collectionviewCategory == .todoList ? todoModel : challModel).sorted(by: { $0.use_yn! > $1.use_yn! } )
            modelList = sortModel
        }
        
        switch collectType {
        case .doing:
            guard let todoDoingModelList = self.challengeCollectModel.todo_progress_count,
                  let chalDoingModelList = self.challengeCollectModel.challenge_progress_count
            else { return [] }
            setModelForCollection(todoDoingModelList, chalDoingModelList)
            return modelList
        case .fail:
            guard let todoFailModelList = self.challengeCollectModel.todo_incomplete_count,
                  let chalFailModelList = self.challengeCollectModel.challenge_incomplete_count
            else { return [] }
            setModelForCollection(todoFailModelList, chalFailModelList)
            return modelList
        case .done:
            guard let todoDoneModelList = self.challengeCollectModel.todo_complete_count,
                  let chalDoneModelList = self.challengeCollectModel.challenge_complete_count
            else { return [] }
            setModelForCollection(todoDoneModelList, chalDoneModelList)
            return modelList
        case .none:
            return []
        }
    }
}

extension MyChallengeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = RadHelper.isIphoneSE1st ? screenwidth * 0.28 : screenwidth * 0.3
        return CGSize(width: size * 1.1, height: size)
    }
}
