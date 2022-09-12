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
    }}

