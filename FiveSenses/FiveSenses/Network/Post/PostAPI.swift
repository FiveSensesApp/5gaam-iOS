//
//  PostAPI.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/14.
//

import Foundation

import Moya

enum PostSortType: String {
    case desc
    case asc
}

enum PostAPI {
    case getPosts(
        page: Int,
        size: Int = 10,
        sort: PostSortType,
        category: FiveSenses? = nil,
        star: Int? = nil,
        createdDate: String? = nil
    )
    case getCountOfPost(
        sense: FiveSenses?,
        star: Int? = nil,
        createdDate: String? = nil
    )
    case createPost(creatingPost: CreatingPost)
}

extension PostAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: Constants.sourceURL + "/posts")!
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return ""
        case .getCountOfPost:
            return "/count"
        case .createPost:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts:
            return .get
        case .getCountOfPost:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts(
            let page,
            let size,
            let sort,
            let category,
            let star,
            let createdDate):
            return .requestParameters(
                parameters: [
                    "userId": Constants.CurrentToken?.userId ?? -1,
                    "page": page,
                    "size": size,
                    "sort": "id,\(sort.rawValue)",
                    "category": category?.category,
                    "star": star,
                    "createdDate": createdDate
                ].compactMapValues { $0 },
                encoding: URLEncoding.default
            )
        case .getCountOfPost(let sense, let star, let createdDate):
            return .requestParameters(
                parameters: [
                    "userId": Constants.CurrentToken?.userId ?? -1,
                    "category": sense?.category,
                    "star": star,
                    "createdDate": createdDate
                ].compactMapValues { $0 },
                encoding: URLEncoding.default
            )
        case .createPost(let creatingPost):
            return .requestJSONEncodable(creatingPost)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    
}
