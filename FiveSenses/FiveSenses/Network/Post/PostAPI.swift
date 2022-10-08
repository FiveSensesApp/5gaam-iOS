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
    case deletePost(post: Post)
    case modifyPost(id: Int, creatingPost: CreatingPost)
    case getIfPostPresent(startDate: Date, endDate: Date)
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
        case .deletePost(let post):
            return "/\(post.id)"
        case .modifyPost(let id, _):
            return "/\(id)"
        case .getIfPostPresent:
            return "/present-between"
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
        case .deletePost:
            return .delete
        case .modifyPost:
            return .patch
        case .getIfPostPresent:
            return .get
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
        case .deletePost:
            return .requestPlain
        case .modifyPost(_, let creatingPost):
            return .requestJSONEncodable(creatingPost)
        case .getIfPostPresent(let startDate, let endDate):
            return .requestParameters(
                parameters: [
                    "startDate": startDate.toString(format: .Parameter) ?? "",
                    "endDate": endDate.toString(format: .Parameter) ?? ""
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    
}
