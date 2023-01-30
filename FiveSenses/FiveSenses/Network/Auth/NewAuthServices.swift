//
//  NewAuthServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/09.
//

import Foundation

import Moya
import RxMoya
import RxSwift
import SwiftJWT
import Toaster

final class NewAuthServices: Networkable {
    typealias Target = NewAuthAPI
    
    static let provider = makeProvider()
    
    static func login(email: String, password: String) -> Observable<LoginResponse?> {
        NewAuthServices.provider
            .rx.request(.login(email: email, password: password))
            .asObservable()
            .map {
                let response = $0.data.decode(LoginResponse.self)
                dump(response)
                if
                    let token = response?.data,
                    let accessToken = token.accessToken,
                    let refreshToken = token.refreshToken
                {
                    KeyChainController.shared.create(Constants.ServiceString, account: "Token", value: accessToken)
                    KeyChainController.shared.create(Constants.ServiceString, account: "RefreshToken", value: refreshToken)
                    
                    Constants.CurrentToken = (try? JWT<TokenContent>(jwtString: accessToken))?.claims
                }
                return response
            }
    }
    
    struct LoginResponse: ResponseBase {
        var meta: APIMeta
        var data: TokenModel?
    }
    
    static func reissue() -> Observable<LoginResponse?> {
        NewAuthServices.provider
            .rx.request(.reissue(accessToken: KeyChainController.shared.read(Constants.ServiceString, account: "Token") ?? "", refreshToken: KeyChainController.shared.read(Constants.ServiceString, account: "RefreshToken") ?? ""))
            .asObservable()
            .map {
                if let response = $0.data.decode(LoginResponse.self) {
                    
                    if
                        let token = response.data,
                        let accessToken = token.accessToken,
                        let refreshToken = token.refreshToken
                    {
                        KeyChainController.shared.create(Constants.ServiceString, account: "Token", value: accessToken)
                        KeyChainController.shared.create(Constants.ServiceString, account: "RefreshToken", value: refreshToken)
                        
                        Constants.CurrentToken = (try? JWT<TokenContent>(jwtString: accessToken))?.claims
                        return response
                    } else {
                        UIApplication.shared.keyWindow?.replaceRootViewController(LoginViewController(), animated: true, completion: nil)
                        return nil
                    }
                } else {
                    UIApplication.shared.keyWindow?.replaceRootViewController(LoginViewController(), animated: true, completion: nil)
                    return nil
                }
                
            }
    }
}

