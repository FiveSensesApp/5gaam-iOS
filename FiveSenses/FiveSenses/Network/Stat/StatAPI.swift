//
//  StatAPI.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/17.
//

import Foundation
import Moya
import RxMoya

enum StatAPI {
    case getStats
}

extension StatAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constants.sourceURL)!
    }
    
    var path: String {
        return "/stats"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: ["userId": "\(Constants.CurrentToken?.userId ?? "-1")"], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
}
