//
//  AuthServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class AuthServices: Networkable {
    typealias Target = AuthAPI
    
    static let provider = makeProvider()
    
    static func createUser(creatingUser: CreatingUser) -> Observable<CreateUserResponse?> {
        AuthServices.provider
            .rx.request(.createUser(creatingUser))
            .asObservable()
            .debug()
            .map {
                let response = $0.data.decode(CreateUserResponse.self)
                dump(response)
                return response
            }
    }
    
    struct CreateUserResponse: Codable {
        var meta: APIMeta
        var data: CreatedUser?
        
        enum CodingKeys: String, CodingKey {
            case meta
            case data
        }
    }
    
    static func login(email: String, password: String) -> Observable<LoginResponse?> {
        AuthServices.provider
            .rx.request(.login(email: email, password: password))
            .asObservable()
            .map {
                let response = $0.data.decode(LoginResponse.self)
                dump(response)
                return response
            }
    }
    
    struct LoginResponse: ResponseBase {
        struct Token: Codable {
            var token: String
        }
        
        var meta: APIMeta
        var data: Token?
    }
}

