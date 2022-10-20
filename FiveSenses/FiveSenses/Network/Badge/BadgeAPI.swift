//
//  BadgeAPI.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/09.
//

import Foundation

import Moya

enum BadgeAPI {
    case getBadge(name: String)
    case getUserBadgesByUser
    case checkUpdate
}

extension BadgeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constants.sourceURL)!
    }
    
    var path: String {
        switch self {
        case .getUserBadgesByUser:
            return "/users/\(Constants.CurrentToken?.userId ?? "")/badges"
        case .getBadge(let name):
            return "/badges/\(name)"
        case .checkUpdate:
            return "/badges/check-updates"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserBadgesByUser:
            return .get
        case .getBadge:
            return .get
        case .checkUpdate:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserBadgesByUser:
            return .requestPlain
        case .getBadge:
            return .requestPlain
        case .checkUpdate:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var authorizationType: Moya.AuthorizationType? {
        .bearer
    }
}
