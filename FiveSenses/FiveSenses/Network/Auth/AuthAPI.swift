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
    case login(email: String, password: String)
    
    struct LoginInfo: Codable {
        var email: String
        var password: String
    }
}

extension AuthAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .createUser:
            return .none
        case .login:
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
        case .login:
            return "/signin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createUser(let creatingUser):
            return .requestJSONEncodable(creatingUser)
        case .login(let email, let password):
            return .requestJSONEncodable(LoginInfo(email: email, password: password))
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
