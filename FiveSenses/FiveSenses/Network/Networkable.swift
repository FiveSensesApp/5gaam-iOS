//
//  Networkable.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Moya

import RxSwift
import RxMoya
import RxCocoa
import Toaster

protocol Networkable {
    associatedtype Target: TargetType
    static func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {
    static func makeProvider() -> MoyaProvider<Target> {
        let authPlugin = AccessTokenPlugin { _ in
            return KeyChainController.shared.getAuthorizationString(service: Constants.ServiceString, account: "Token") ?? ""
        }
        
        let loggerPlugin = NetworkLoggerPlugin()
        
        return MoyaProvider<Target>(plugins: [authPlugin, loggerPlugin])
    }
}

enum TokenError: Swift.Error {
    case tokenExpired
}

extension MoyaProvider {
    func requestWithToken(_ token: Target) -> Single<Response> {
        return self.rx.request(token)
            .retry(1)
            .map {
                // 401(Unauthorized) 발생 시 자동으로 토큰을 재발급 받는다
                
                if $0.statusCode == 401 {
                    throw TokenError.tokenExpired
                } else {
                    return $0
                }
            }
            .retry { (error: Observable<TokenError>) in
                return error.flatMap {
                    if $0 == TokenError.tokenExpired {
                        return NewAuthServices.reissue()
                    } else {
                        return Observable.just(nil)
                    }
                }.filter { $0 != nil }
                
            }
    }
}

//extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
//    
//    // Tries to refresh auth token on 401 error and retry the request.
//    // If the refresh fails it returns an error .
//    public func refreshAuthenticationTokenIfNeeded(sessionServiceDelegate : SessionProtocol) -> Single<Response> {
//        return self.retryWhen { responseFromFirstRequest in
//            responseFromFirstRequest.flatMap { originalRequestResponseError -> PrimitiveSequence<SingleTrait, Element> in
//                if let lucidErrorOfOriginalRequest : LucidMoyaError = originalRequestResponseError as? LucidMoyaError {
//                    let statusCode = lucidErrorOfOriginalRequest.statusCode!
//                    if statusCode == 401 {
//                        // Token expired >> Call refresh token request
//                        return sessionServiceDelegate
//                            .getTokenRefreshService()
//                            .filterSuccessfulStatusCodesAndProcessErrors()
//                            .catchError { tokeRefreshRequestError -> Single<Response> in
//                                // Failed to refresh token
//                                if let lucidErrorOfTokenRefreshRequest : LucidMoyaError = tokeRefreshRequestError as? LucidMoyaError {
//                                    //
//                                    // Logout or do any thing related
//                                    sessionServiceDelegate.didFailedToRefreshToken()
//                                    //
//                                    return Single.error(lucidErrorOfTokenRefreshRequest)
//                                }
//                                return Single.error(tokeRefreshRequestError)
//                            }
//                            .flatMap { tokenRefreshResponseString -> Single<Response> in
//                                // Refresh token response string
//                                // Save new token locally to use with any request from now on
//                                sessionServiceDelegate.tokenDidRefresh(response: try! tokenRefreshResponseString.mapString())
//                                // Retry the original request one more time
//                                return self.retry(1)
//                            }
//                    }
//                    else {
//                        // Retuen errors other than 401 & 403 of the original request
//                        return Single.error(lucidErrorOfOriginalRequest)
//                    }
//                }
//                // Return any other error
//                return Single.error(originalRequestResponseError)
//            }
//        }
//    }
//}
