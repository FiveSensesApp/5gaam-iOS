//
//  AuthAPI.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

import Moya
import RxMoya

enum AuthAPI {
    case createUser(_ creatingUser: CreatingUser)
}

extension AuthAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .createUser:
            return .none
        }
    }
    
    var baseURL: URL {
        return URL(string: Constants.sourceURL + "/auth")!
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createUser(let creatingUser):
            return .requestJSONEncodable(creatingUser)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
