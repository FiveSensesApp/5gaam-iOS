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
        var postDistribution = BehaviorRelay<[(sense: FiveSenses, count: Int)]>(value: [])
        var thisMonthSense = PublishRelay<MonthlyCategory?>()
        var monthlySenses = BehaviorRelay<[MonthlyCategory]>(value: [])
        var totalCount = PublishRelay<Int>()
        var countByDay = BehaviorRelay<[CountByDay]>(value: [])
        var countByMonth = BehaviorRelay<[CountByMonth]>(value: [])
    }
    
    var input: Input?
    var output: Output? = Output()
    private var postDistribution: [(sense: FiveSenses, count: Int)] = [] {
        didSet {
            if self.postDistribution.count == 6 {
                self.output!.postDistribution.accept(self.postDistribution)
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    init(input: Input) {
        self.input = input
    }
    
    func reloadUserInfo() {
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
        
        
        
        FiveSenses.allCases.forEach { sense in
            PostServices.getCountOfPost(sense: sense)
                .bind { [weak self] in
                    self?.postDistribution.append((sense: sense, count: $0))
                }
                .disposed(by: self.disposeBag)
        }
        
        UserServices.getUserInfo()
            .bind(to: self.output!.userInfo)
            .disposed(by: self.disposeBag)
        
        StatServices.getStat()
            .compactMap { $0 }
            .bind { [weak self] data in
                guard let self = self else { return }
                
                self.output!.thisMonthSense.accept(data.monthlyCategoryDtoList.filter { $0.month.isInSameMonth(as: Date()) }.first)
                self.output!.monthlySenses.accept(data.monthlyCategoryDtoList)
                self.output!.totalCount.accept(data.totalPost)
                self.output!.countByDay.accept(data.countByDayDtoList)
                self.output!.countByMonth.accept(data.countByMonthDtoList)
            }
            .disposed(by: self.disposeBag)
    }
}
