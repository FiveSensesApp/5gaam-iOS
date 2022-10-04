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
       
        self.postMenuView.deleteButtonTapped
            .asObservable()
            .bind { [weak self] _ in
                self?.dismissPostMenu()
                self?.showDeleteAlert()
            }
            .disposed(by: disposeBag)
        
        self.postMenuView.modifyButtonTapped
            .asObservable()
            .bind { [weak self] _ in
                let vc = ModifyPostViewController()
                vc.currentPost = self?.postMenuView.post
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
                self?.dismissPostMenu()
            }
            .disposed(by: disposeBag)
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.filterCollectionView.indexPathsForSelectedItems.isNilOrEmpty {
            self.filterCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            self.viewModel.loadPosts(loadingType: .refresh)
        }
    }
    
    private func showDeleteAlert() {
        self.view.endEditing(true)
        
        let alert = TwoButtonAlertController(title: "정말 삭제하시겠어요?", content: "삭제한 취향은 복구할 수 없어요.", okButtonTitle: "뒤로 가기", cancelButtonTitle: "삭제 하기")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        alert.okButton.rx.tap
            .bind {
                alert.dismiss(animated: true)
            }.disposed(by: disposeBag)
        alert.cancelButton.rx.tap
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self, let post = self.postMenuView.post else { return Observable.just(false) }
                
                return PostServices.deletePost(post: post)
            }
            .bind { [weak self] in
                guard let self = self else { return }
                if $0 {
                    self.viewModel.loadPosts(loadingType: .refresh)
                }
                self.dismissPostMenu()
                alert.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        self.present(alert, animated: true)
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
            cell.tastesView.menuButton
                .rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    self?.showPostMenu(menuButtonFrame: cell.frame, post: post)
                }
                .disposed(by: cell.disposeBag)
        default:
            break
        }
    }
    
    func select(model: Any) {
        self.dismissPostMenu()
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
