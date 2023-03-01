//
//  SearchPostViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/29.
//

import Foundation

import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class SearchPostViewModel: BaseViewModel {
    struct Input {
        var searchText = PublishRelay<String>()
        var deleteAllButtonTapped: ControlEvent<Void>
        var reloadRecentSearchTexts = PublishRelay<Void>()
    }
    
    struct Output {
        var recentSearchTexts = BehaviorRelay<[String]>(value: Defaults[\.recentSearchTexts])
        var searchResults = BehaviorRelay<[Post]>(value: [])
    }
    
    var input: Input?
    var output: Output? = Output()
    
    private var disposeBag = DisposeBag()
    
    init(input: Input) {
        self.input = input
        
        self.input!.searchText
            .flatMap {
                PostServices.searchPosts(with: $0)
            }
            .bind(to: self.output!.searchResults)
            .disposed(by: self.disposeBag)
        
        self.input!.reloadRecentSearchTexts
            .map {
                Defaults[\.recentSearchTexts]
            }
            .bind(to: self.output!.recentSearchTexts)
            .disposed(by: self.disposeBag)
        
        self.input!.deleteAllButtonTapped
            .asObservable()
            .do { _ in
                Defaults[\.recentSearchTexts] = []
            }
            .map {
                return ()
            }
            .bind(to: self.input!.reloadRecentSearchTexts)
            .disposed(by: self.disposeBag)
    }
}
