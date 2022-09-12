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
