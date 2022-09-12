//
//  UserAPI.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

import Moya
import RxMoya

enum UserAPI {
    case validateDuplicate(_ email: String)
    
    struct SendingEmail: Codable {
        var email: String
    }
}

extension UserAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constants.sourceURL + "/users")!
    }
    
    var path: String {
        switch self {
        case .validateDuplicate:
            return "/validate-duplicate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validateDuplicate:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .validateDuplicate(let email):
            return .requestJSONEncodable(SendingEmail(email: email))
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .validateDuplicate:
            return .none
        }
    }
}
