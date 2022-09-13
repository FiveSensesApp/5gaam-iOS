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
    case validateEmail(_ email: String)
    case validateEmailSendCode(email: String, code: String)
    
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
        case .validateEmail:
            return "/validate-email"
        case .validateEmailSendCode:
            return "/validate-email-send-code"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validateDuplicate:
            return .post
        case .validateEmail:
            return .post
        case .validateEmailSendCode:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .validateDuplicate(let email):
            return .requestJSONEncodable(SendingEmail(email: email))
        case .validateEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.default)
        case .validateEmailSendCode(let email, let code):
            return .requestParameters(parameters: ["email": email, "emailCode": code], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .validateDuplicate:
            return .none
        case .validateEmail:
            return .none
        case .validateEmailSendCode:
            return .none
        }
    }
}
