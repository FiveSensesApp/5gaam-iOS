//
//  TokenModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/08.
//

import Foundation

struct TokenModel: Codable {
    var grantType: String
    var accessToken: String?
    var refreshToken: String?
    var accessTokenExpiresIn: Date?
    
    enum CodingKeys: String, CodingKey {
        case grantType
        case accessToken
        case refreshToken
        case accessTokenExpiresIn
    }
    
    init(grantType: String, accessToken: String, refreshToken: String) {
        self.grantType = grantType
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        grantType = try values.decode(String.self, forKey: .grantType)
        accessToken = try values.decode(String.self, forKey: .accessToken)
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
        accessTokenExpiresIn = try values.decode(Date.self, forKey: .accessTokenExpiresIn)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(grantType, forKey: .grantType)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(accessTokenExpiresIn, forKey: .accessTokenExpiresIn)
    }
}
