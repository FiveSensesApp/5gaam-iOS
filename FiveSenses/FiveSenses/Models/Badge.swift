//
//  Badge.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/09.
//

import Foundation

struct Badge: Codable {
//    "id": "1_획득전_첫 감각의 설렘.svg",
//       "seqNum": 1,
//       "imgUrl": "https://elasticbeanstalk-ap-northeast-2-667624151880.s3.ap-northeast-2.amazonaws.com/images/badges_before/1_%ED%9A%8D%EB%93%9D%EC%A0%84_%EC%B2%AB%20%EA%B0%90%EA%B0%81%EC%9D%98%20%EC%84%A4%EB%A0%98.svg",
//       "description": "첫 기록의 설렘을 간직해보세요",
//       "reqCondition": null,
//       "reqConditionShort": "첫 기록 작성",
//       "isBefore": true,
//       "name": "첫 감각의 설렘"

    var badgeId: String
    var seqNum: Int
    var imgUrl: String
    var description: String?
    var reqCondition: String?
    var reqConditionShort: String?
    var isBefore: Bool
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case badgeId = "id"
        case seqNum
        case imgUrl
        case description
        case reqCondition
        case reqConditionShort
        case isBefore
        case name
    }
}
