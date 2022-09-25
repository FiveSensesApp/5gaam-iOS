//
//  ScoreViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/22.
//

import UIKit

class ScoreViewController: BaseTastesViewController {
    let filterTitles = ["5점", "4점", "3점", "2점", "1점"]
    
    lazy var adapter = Adapter(collectionView: self.tastesCollectionView)
    var viewModel = TastesStorageViewModel()
    
    override func loadView() {
        super.loadView()
        
        self.filterCollectionView.snp.remakeConstraints {
            $0.height.equalTo(60.0)
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        self.filterCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 12.0, left: 21.0, bottom: 12.0, right: 21.0)
            $0.minimumInteritemSpacing = 10.0
            $0.scrollDirection = .horizontal
        }
        
        self.tastesCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 29.0, right: 0.0)
        }
        
        self.firstWriteView.isHidden = true
        
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adapter.delegate = self
        self.tastesCollectionView.delegate = self.adapter
        self.tastesCollectionView.dataSource = self.adapter
        
        self.adapter.reload(sections: self.viewModel.toCollectionSections(cellType: KeywordTastesCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.loadPosts()
    }
}

extension ScoreViewController: AdapterDelegate {
    func configure(model: Any, view: UIView, indexPath: IndexPath) {
        guard let model = model as? Model else { return }
        
        switch (model, view) {
        case (.header(let count), let view as TastesTotalCountHeaderView):
            view.totalCountLabel.text = "총 \(count)개"
        case (.post(let post), let cell as KeywordTastesCell):
            cell.configure(post: post)
        default:
            break
        }
    }
    
    func select(model: Any) {
        
    }
    
    func size(model: Any, containerSize: CGSize) -> CGSize {
        guard let model = model as? Model else { return .zero }
        
        switch model {
        case .header:
            return CGSize(width: Constants.DeviceWidth, height: 12.0)
        case .post:
            return CGSize(width: Constants.DeviceWidth - 40.0, height: 50.0)
        }
    }
}

extension ScoreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TastesFilterCell.identifier, for: indexPath) as! TastesFilterCell
        cell.titleLabel.text = filterTitles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.filterTitles[indexPath.item] as NSString).size(withAttributes: [.font: UIFont.bold(16.0)]).width
        
        return CGSize(width: width + 29.0, height: 36.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 12.0, left: 21.0, bottom: 12.0, right: 21.0)
//    }
}
