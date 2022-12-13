//
//  StatServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/17.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import RxCocoa

final class StatServices: Networkable {
    typealias Target = StatAPI
    
    static let provider = makeProvider()
    
    struct StatResponse: ResponseBase {
        struct Data: Codable {
            var totalPost: Int
            var percentageOfCategory: PercentageOfCategory
            var monthlyCategoryDtoList: [MonthlyCategory]
            var countByDayDtoList: [CountByDay]
            var countByMonthDtoList: [CountByMonth]
        }
        
        var meta: APIMeta
        var data: Data?
    }
    
    static func getStat() -> Observable<StatResponse.Data?> {
        StatServices.provider
            .rx.request(.getStats)
            .asObservable()
            .map {
                let response = $0.data.decode(StatResponse.self)
                return response?.data
            }
    }
}

struct PercentageOfCategory: Codable {
    var HEARING: Double
    var TOUCH: Double
    var SMELL: Double
    var TASTE: Double
    var AMBIGUOUS: Double
    var SIGHT: Double
}

struct MonthlyCategory: Codable {
    var month: Date
    var category: FiveSenses
    var cnt: Int
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        month = try values.decode(Date.self, forKey: .month)
        cnt = try values.decode(Int.self, forKey: .cnt)
        let categoryString = try values.decode(String.self, forKey: .category)
        switch categoryString {
        case "HEARING":
            self.category = .hearing
        case "TOUCH":
            self.category = .touch
        case "SMELL":
            self.category = .smell
        case "TASTE":
            self.category = .taste
        case "AMBIGUOUS":
            self.category = .dontKnow
        case "SIGHT":
            self.category = .sight
        default:
            self.category = .none
        }
    }
}

struct CountByDay: Codable {
    var day: Date
    var count: Int
}

struct CountByMonth: Codable {
    var month: Date
    var count: Int
}
