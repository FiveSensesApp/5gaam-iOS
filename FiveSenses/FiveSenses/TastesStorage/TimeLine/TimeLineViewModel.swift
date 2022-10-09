//
//  TimeLineViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/21.
//

import UIKit

import RxSwift
import RxCocoa

class TimeLineViewModel: BaseViewModel {
    struct Input {
        var currentSortType = BehaviorRelay<PostSortType>(value: .desc)
    }
    struct Output {
        var tastePosts = BehaviorRelay<[Post]>(value: [])
        var numberOfPosts = BehaviorRelay<Int>(value: 0)
    }
    
    var input: Input?
    var output: Output? = Output()
    
    var currentPage = 0
    
    private var disposeBag = DisposeBag()
    
    init() {
        self.input = Input()
        
        NotificationCenter.default.addObserver(self, selector: #selector(writeBottomSheetDidDismiss), name: .didWriteViewDismiss, object: nil)

        self.input!.currentSortType
            .bind { [weak self] _ in
                self?.currentPage = 0
                self?.output!.tastePosts.accept([])
                self?.loadPosts(loadingType: .refresh)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func writeBottomSheetDidDismiss() {
        self.loadPosts(loadingType: .refresh)
    }
    
    func loadPosts(loadingType: PostLoadingType = .more) {
        PostServices.getCountOfPost()
            .do {
                Constants.TotalCountOfPost = $0
            }
            .bind(to: self.output!.numberOfPosts)
            .disposed(by: self.disposeBag)
        
        let pageToLoad = (loadingType == .refresh) ? 0 : self.currentPage
        
        PostServices.getPosts(
            page: pageToLoad,
            size: 10,
            sort: self.input!.currentSortType.value,
            category: nil,
            star: nil,
            createdDate: nil)
        .map { [weak self] in
            guard let self = self else { return [] }
            switch loadingType {
            case .refresh:
                var newPost: [Post] = []
                for post in ($0?.data?.content ?? []) {
                    if !self.output!.tastePosts.value.contains(where: { $0.id == post.id }) {
                        newPost.append(post)
                    }
                }
                
                return newPost + self.output!.tastePosts.value
            case .more:
                self.currentPage += 1
                var newPost: [Post] = []
                for post in ($0?.data?.content ?? []) {
                    if !self.output!.tastePosts.value.contains(where: { $0.id == post.id }) {
                        newPost.append(post)
                    }
                }
                
                return self.output!.tastePosts.value + newPost
            }
        }
        .bind(to: self.output!.tastePosts)
        .disposed(by: self.disposeBag)
    }
    
    func toCollectionSections<T>(cellType: T.Type) -> [Section] where T: UICollectionViewCell {
        var items: [Item] = []
        
        for post in self.output?.tastePosts.value ?? [] {
            items.append(Item(model: BaseTastesViewController.Model.post(post), cellType: cellType))
        }
        
        return [Section(
            header: Header(model: BaseTastesViewController.Model.header("\(self.output?.numberOfPosts.value ?? 0)"), viewType: TastesTotalCountHeaderView.self),
            items: items
        )]
    }
    
}

enum PostLoadingType {
    case refresh
    case more
}
