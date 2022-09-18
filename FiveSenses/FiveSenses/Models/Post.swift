//
//  Post.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/14.
//

import Foundation

struct Post: Codable {
    var id: Int
    var category: FiveSenses
    var keyword: String
    var star: Int
    var content: String
    var createdDate: Date
    var modifiedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case keyword
        case star
        case content
        case createdDate
        case modifiedDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        let categoryString = try values.decode(String.self, forKey: .category)
        category = FiveSenses.senseByCategory(category: categoryString)
        keyword = try values.decode(String.self, forKey: .keyword)
        star = try values.decode(Int.self, forKey: .star)
        content = try values.decode(String.self, forKey: .content)
        createdDate = try values.decode(Date.self, forKey: .createdDate)
        modifiedDate = try values.decode(Date.self, forKey: .modifiedDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category.category, forKey: .category)
        try container.encode(keyword, forKey: .keyword)
        try container.encode(star, forKey: .star)
        try container.encode(content, forKey: .content)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(modifiedDate, forKey: .modifiedDate)
    }
}
