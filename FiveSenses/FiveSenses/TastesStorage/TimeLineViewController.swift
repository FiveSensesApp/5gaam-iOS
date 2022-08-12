//
//  TimeLineViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/12.
//

import UIKit

final class TimeLineViewController: BaseTastesViewController {
    let filterTitles = ["최신순", "오래된순"]
    
    override func loadView() {
        super.loadView()
        
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.tastesCollectionView.delegate = self
        self.tastesCollectionView.dataSource = self
        
        self.filterCollectionView.snp.remakeConstraints {
            $0.height.equalTo(60.0)
            $0.top.equalToSuperview()
            $0.width.equalTo(90.0 * 2.0 + 10.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.filterCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 90.0, height: 36.0)
            $0.sectionInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
            $0.minimumInteritemSpacing = 10.0
        }
        
        self.tastesCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 29.0, right: 0.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.filterCollectionView.indexPathsForSelectedItems.isNilOrEmpty {
            self.filterCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        }
    }
}

extension TimeLineViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.filterCollectionView {
            return 2
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TastesFilterCell.identifier, for: indexPath) as! TastesFilterCell
            cell.titleLabel.text = filterTitles[indexPath.item]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
