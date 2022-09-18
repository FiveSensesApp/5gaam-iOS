//
//  CreatingUser.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

import SwiftJWT

struct CreatingUser: Codable {
    var nickname: String
    var isAlarmOn: Bool
    var email: String
    var password: String
    var alarmDate: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case isAlarmOn
        case alarmDate
        case email
        case password
    }
}

struct CreatedUser: Codable {
    var id: Int
    var nickname: String
    var isAlarmOn: Bool
    var alarmDate: Date?
    var email: String
    var emailValidCode: String?
    var createdDate: Date
    var modifiedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case isAlarmOn
        case alarmDate
        case email
        case emailValidCode
        case createdDate
        case modifiedDate
    }
}

struct TokenContent: Codable, Claims {
    var userId: String
    var auth: String
    var exp: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "sub"
        case auth
        case exp
    }
}
