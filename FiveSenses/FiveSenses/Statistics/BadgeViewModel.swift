//
//  BadgeViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/10.
//

import Foundation

import RxSwift
import RxCocoa

class BadgeViewModel: BaseViewModel {
    struct Input {
        
    }
    
    struct Output {
        var representBadge = BehaviorRelay<Badge?>(value: nil)
        var badges = BehaviorRelay<[Badge]>(value: [])
    }
    
    var input: Input?
    var output: Output? = Output()
    
    var disposeBag = DisposeBag()
    
    init(input: Input? = nil) {
        self.input = input
        
        UserServices.getUserInfo()
            .compactMap { $0 }
            .map {
                $0.badgeRepresent
            }
            .flatMap { name -> Observable<Badge?> in
                if let name = name {
                    return BadgeServices.getBadge(by: name)
                } else {
                    return Observable.just(nil)
                }
            }
            .bind(to: self.output!.representBadge)
            .disposed(by: disposeBag)
            
        
        BadgeServices.getUserBadgesByUser()
            .bind(to: self.output!.badges)
            .disposed(by: disposeBag)
    }
}
