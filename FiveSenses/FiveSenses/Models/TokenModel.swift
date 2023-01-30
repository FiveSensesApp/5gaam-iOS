//
//  TokenModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/08.
//

import Foundation

//"grantType": "Bearer",
//"accessToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxOTkiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNjczMTU2MTU5fQ.t1xSM7bgPkOkp0YBt1zi4kzd1koka6XTEQd4UgWvSGZmHHkuprAY6W8M0qzrWTBF-cRxcM22BnM6q8FgtAQ3Yw",
//"refreshToken": "eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2NzM3NTkxNTl9.dA0OOcA2NtagO2V8nM7mTNs6B0DYx-kpR84fWWMV8V103Nbfbnm2abaUv8sTKfVOpyV5qLHXBh_jCj6vZmjSog",
//"accessTokenExpiresIn": 1673156159908

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
