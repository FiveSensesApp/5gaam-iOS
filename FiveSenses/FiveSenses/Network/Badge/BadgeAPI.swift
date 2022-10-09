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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserBadgesByUser:
            return .get
        case .getBadge:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserBadgesByUser:
            return .requestPlain
        case .getBadge:
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
