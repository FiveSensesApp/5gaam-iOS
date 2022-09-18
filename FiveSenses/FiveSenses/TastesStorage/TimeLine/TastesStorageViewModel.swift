//
//  TastesStorageViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/21.
//

import UIKit

import RxSwift
import RxCocoa

class TastesStorageViewModel: BaseViewModel {
    struct Input {
        var currentSortType = BehaviorRelay<PostSortType>(value: .desc)
        var currentCategory = BehaviorRelay<FiveSenses?>(value: nil)
        var currentStar = BehaviorRelay<Int?>(value: nil)
    }
    struct Output {
        var tastePosts = BehaviorRelay<[Post]>(value: [])
        var numberOfPosts = BehaviorRelay<Int>(value: 0)
    }
    
    var input: Input?
    var output: Output? = Output()
    
    var currentPage = 0
    
    private var disposeBag = DisposeBag()
    
    init(input: Input? = nil) {
        self.input = input
    }
    
    func loadPosts() {
        PostServices.getCountOfPost(sense: self.input?.currentCategory.value ?? .dontKnow)
           .bind(to: self.output!.numberOfPosts)
           .disposed(by: self.disposeBag)
        
        PostServices.getPosts(
            page: currentPage,
            size: 10,
            sort: self.input?.currentSortType.value ?? .desc,
            category: self.input?.currentCategory.value,
            star: self.input?.currentStar.value,
            createdDate: nil)
        .map { [weak self] in
            guard let self = self else { return [] }
            return self.output!.tastePosts.value + ($0?.data?.content ?? [])
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
            header: Header(model: BaseTastesViewController.Model.header("2"), viewType: TastesTotalCountHeaderView.self),
            items: items
        )]
    }
    
}
