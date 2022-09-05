//
//  TastePost.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/16.
//

import Foundation

final class TastePost: Codable {
    var id: Int!
    var sense: FiveSenses!
    var keyword: String!
    var star: Int!
    var content: String?
    var createdDate: Date!
    var modifiedDate: Date!
    
    init(id: Int, sense: FiveSenses, keyword: String, star: Int, content: String, createdDate: Date, modifiedDate: Date) {
        self.id = id
        self.sense = sense
        self.keyword = keyword
        self.star = star
        self.content = content
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
