//
//  StatViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/09.
//

import Foundation

import RxSwift
import RxCocoa

class StatViewModel: BaseViewModel {
    struct Input {
        
    }
    
    struct Output {
        var userInfo = BehaviorRelay<UserInfo?>(value: nil)
        var representBadgeUrl = BehaviorRelay<String?>(value: nil)
        var previewBadgesUrl = BehaviorRelay<[String]>(value: [])
    }
    
    var input: Input?
    var output: Output? = Output()
    
    private var disposeBag = DisposeBag()
    
    init(input: Input) {
        self.input = input
        
        self.output!.userInfo
            .compactMap {
                $0?.badgeRepresent
            }
            .flatMap {
                BadgeServices.getBadgeImageUrl(by: $0)
            }
            .bind(to: self.output!.representBadgeUrl)
            .disposed(by: self.disposeBag)
        
        BadgeServices.getUserBadgesByUser()
            .filter { $0.count >= 4 }
            .map {
                return [$0[0].imgUrl, $0[1].imgUrl, $0[2].imgUrl, $0[3].imgUrl]
            }
            .bind(to: self.output!.previewBadgesUrl)
            .disposed(by: self.disposeBag)
    }
    
    func reloadUserInfo() {
        UserServices.getUserInfo()
            .bind(to: self.output!.userInfo)
            .disposed(by: self.disposeBag)
    }
}
