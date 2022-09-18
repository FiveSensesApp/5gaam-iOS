//
//  ResponseBase.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

protocol ResponseBase: Codable {
    associatedtype Data
    
    var meta: APIMeta { get set }
    var data: Data? { get set }
}

struct Sort: Codable {
    var sorted: Bool
    var unsorted: Bool
    var empty: Bool
}

struct Pageble: Codable {
    
    var sort: Sort
    var pageNumber: Int
    var pageSize: Int
    var offset: Int
    var unpaged: Bool
    var paged: Bool
}

struct PageInfo: Codable {
    var number: Int
    var first: Bool
    var last: Bool
    var sort: Sort
    var numberOfElements: Int
    var size: Int
    var empty: Bool
}
