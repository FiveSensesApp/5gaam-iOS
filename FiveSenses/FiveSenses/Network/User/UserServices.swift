//
//  UserServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

import Moya
import RxSwift

class UserServices: Networkable {
    typealias Target = UserAPI
    
    static let provider = makeProvider()
    
    static func validateDuplicate(email: String) -> Observable<ValidateDuplicateResponse?> {
        UserServices.provider
            .rx.request(.validateDuplicate(email))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                dump(response)
                return response
            }
    }
    
    struct ValidateDuplicateResponse: ResponseBase {
        var meta: APIMeta
        var data: String?
    }
}
