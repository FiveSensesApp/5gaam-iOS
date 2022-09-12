//
//  Networkable.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Moya

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
