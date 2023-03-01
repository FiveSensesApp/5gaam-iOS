//
//  NewAuthAPI.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/09.
//

import Foundation

import Moya

enum NewAuthAPI {
    case login(email: String, password: String)
    case reissue(accessToken: String, refreshToken: String)
    
    struct LoginInfo: Codable {
        var email: String
        var password: String
    }
}

extension NewAuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.sourceURL + "/auth")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .reissue:
            return "/reissue"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let email, let password):
            return .requestJSONEncodable(LoginInfo(email: email, password: password))
        case .reissue(let accessToken, let refreshToken):
            return .requestJSONEncodable(TokenModel(grantType: "Bearer", accessToken: accessToken, refreshToken: refreshToken))
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    
}
