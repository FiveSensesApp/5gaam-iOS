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
    
    /// 이메일로 코드 전송
    static func validateEmail(email: String) -> Observable<Bool> {
        UserServices.provider
            .rx.request(.validateEmail(email))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                return response?.meta.code == 200
            }
    }
    
    /// 코드 올바른지 확인
    static func validateEmailSendCode(email: String, code: String) -> Observable<Bool> {
        UserServices.provider
            .rx.request(.validateEmailSendCode(email: email, code: code))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                return response?.meta.code == 200
            }
            
    }
    
    struct ValidateDuplicateResponse: ResponseBase {
        var meta: APIMeta
        var data: String?
    }
}
