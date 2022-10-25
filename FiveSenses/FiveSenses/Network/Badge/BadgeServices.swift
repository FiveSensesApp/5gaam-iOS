//
//  BadgeServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/09.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class BadgeServices: Networkable {
    typealias Target = BadgeAPI
    
    static let provider = makeProvider()
    
    struct BadgesResponse: ResponseBase {
        var meta: APIMeta
        var data: [Badge]?
    }
    
    static func getUserBadgesByUser() -> Observable<[Badge]> {
        BadgeServices.checkUpdate()
            .flatMap { val -> Observable<[Badge]> in
                if val == nil {
                    return Observable.just([])
                } else {
                    return BadgeServices.provider
                        .rx.request(.getUserBadgesByUser)
                        .asObservable()
                        .map {
                            let response = $0.data.decode(BadgesResponse.self)
                            return response?.data ?? []
                        }
                }
            }
    }
    
    struct BadgeResponse: ResponseBase {
        var meta: APIMeta
        var data: Badge?
    }
    
    static func getBadgeImageUrl(by name: String) -> Observable<String?> {
        BadgeServices.provider
            .rx.request(.getBadge(name: name))
            .asObservable()
            .map {
                let response = $0.data.decode(BadgeResponse.self)
                return response?.data?.imgUrl
            }
    }
    
    static func getBadge(by name: String) -> Observable<Badge?> {
        BadgeServices.provider
            .rx.request(.getBadge(name: name))
            .asObservable()
            .map {
                let response = $0.data.decode(BadgeResponse.self)
                return response?.data
            }
    }
    
    static func checkUpdate() -> Observable<[Badge]?> {
        BadgeServices.provider
            .rx.request(.checkUpdate)
            .asObservable()
            .map {
                let response = $0.data.decode(BadgesResponse.self)
                return response?.data
            }
    }
    
    static func createUserBadge(badge: Badge) -> Observable<Bool> {
        BadgeServices.provider
            .rx.request(.createUserBadge(badge: badge))
            .asObservable()
            .map {
                return $0.statusCode == 200
            }
    }
}

