//
//  TimeLineViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/12.
//

import UIKit

import RxSwift
import ESPullToRefresh

final class TimeLineViewController: BaseTastesViewController {
    let filterTitles = ["최신순", "오래된순"]
    
    lazy var adapter = Adapter(collectionView: self.tastesCollectionView)
    var viewModel = TastesStorageViewModel()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        
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
        
        self.firstWriteView.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setFirstWriteView(userNickname: "워니버니")
        
        self.adapter.delegate = self
        self.tastesCollectionView.delegate = self.adapter
        self.tastesCollectionView.dataSource = self.adapter
        
        self.viewModel.output?.numberOfPosts
            .debug("포스트 갯수")
            .bind { [weak self] in
                guard let self = self else { return }
                if let headerView = self.tastesCollectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? TastesTotalCountHeaderView {
                    headerView.totalCountLabel.text = "총 \($0)개"
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.output?.tastePosts
            .bind { [weak self] _ in
                self?.adapter.reload(sections: self?.viewModel.toCollectionSections(cellType: ContentTastesCell.self) ?? [])
            }
            .disposed(by: disposeBag)
        
        self.tastesCollectionView.es.addInfiniteScrolling(animator: RefreshFooterView(frame: .zero), handler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.loadPosts(loadingType: .more)
                self.tastesCollectionView.es.stopLoadingMore()
            })
        })
        
//        self.tastesCollectionView.es.addInfiniteScrolling {
//            self.viewModel.loadPosts(loadingType: .more)
//            self.tastesCollectionView.es.stopLoadingMore()
//            self.tastesCollectionView.es.noticeNoMoreData()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.filterCollectionView.indexPathsForSelectedItems.isNilOrEmpty {
            self.filterCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            self.viewModel.loadPosts(loadingType: .refresh)
        }
    }
}

extension TimeLineViewController: AdapterDelegate {
    func configure(model: Any, view: UIView, indexPath: IndexPath) {
        guard let model = model as? Model else { return }
        
        switch (model, view) {
        case (.header(let count), let view as TastesTotalCountHeaderView):
            view.totalCountLabel.text = "총 \(count)개"
        case (.post(let post), let cell as ContentTastesCell):
            cell.configure(tastePost: post)
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
        case .post(let post):
            if post.content == "" {
                return CGSize(width: Constants.DeviceWidth - 40.0, height: 187.0)
            } else {
                return CGSize(width: Constants.DeviceWidth - 40.0, height: 335.0)
            }
        }
    }
}

extension TimeLineViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.filterTitles[indexPath.item] == "최신순" {
            self.viewModel.input?.currentSortType.accept(.desc)
        } else if self.filterTitles[indexPath.item] == "오래된순" {
            self.viewModel.input?.currentSortType.accept(.asc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TastesFilterCell.identifier, for: indexPath) as! TastesFilterCell
        cell.titleLabel.text = filterTitles[indexPath.item]
        return cell
    }
}
