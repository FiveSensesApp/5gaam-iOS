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
    case lostPassword(email: String)
    case getUserInfo
    case updateUser(updatingUser: UpdatingUser)
    case changePassword(old: String, new: String)
    case deleteUser
    
    struct SendingEmail: Codable {
        var email: String
    }
    
    struct ChangePassword: Codable {
        var ogPw: String
        var newPw: String
    }
}

extension UserAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constants.sourceURL)!
    }
    
    var path: String {
        switch self {
        case .validateDuplicate:
            return "/users/validate-duplicate"
        case .validateEmail:
            return "/users/validate-email"
        case .validateEmailSendCode:
            return "/users/validate-email-send-code"
        case .lostPassword:
            return "/users/lost-pw"
        case .getUserInfo:
            return "/users/\(Constants.CurrentToken?.userId ?? "-1")"
        case .updateUser:
            return "/users/\(Constants.CurrentToken?.userId ?? "-1")"
        case .changePassword:
            return "/users/change-pw"
        case .deleteUser:
            return "/admin/users/\(Constants.CurrentToken?.userId ?? "-1")"
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
        case .lostPassword:
            return .post
        case .getUserInfo:
            return .get
        case .updateUser:
            return .put
        case .changePassword:
            return .post
        case .deleteUser:
            return .delete
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
        case .lostPassword(let email):
            return .requestParameters(parameters: ["userEmail": email], encoding: URLEncoding.default)
        case .getUserInfo:
            return .requestPlain
        case .updateUser(let updatingUser):
            return .requestJSONEncodable(updatingUser)
        case .changePassword(let old, let new):
            return .requestJSONEncodable(ChangePassword(ogPw: old, newPw: new))
        case .deleteUser:
            return .requestPlain
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
        case .lostPassword:
            return .none
        case .getUserInfo:
            return .bearer
        case .updateUser:
            return .bearer
        case .changePassword:
            return .bearer
        case .deleteUser:
            return .bearer
        }
    }
}
