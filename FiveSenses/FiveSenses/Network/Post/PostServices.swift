//
//  PostServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/14.
//

import Foundation

import Moya
import RxSwift
import RxMoya

class PostServices: Networkable {
    typealias Target = PostAPI
    
    static let provider = makeProvider()
    
    struct PostsResponse: ResponseBase {
        struct Data: Codable {
            var content: [Post]
            var pageable: Pageble
            var pageInfo: PageInfo
            
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                content = try values.decode([Post].self, forKey: .content)
                pageable = try values.decode(Pageble.self, forKey: .pageable)
                pageInfo = try decoder.singleValueContainer().decode(PageInfo.self)
            }
        }
        
        var meta: APIMeta
        var data: Data?
    }
    
    static func getPosts(page: Int,
                         size: Int = 10,
                         sort: PostSortType,
                         category: FiveSenses? = nil,
                         star: Int? = nil,
                         createdDate: String? = nil) -> Observable<PostsResponse?> {
        PostServices.provider
            .rx.request(.getPosts(page: page, size: size, sort: sort, category: category, star: star, createdDate: createdDate))
            .asObservable()
            .map {
                let response = $0.data.decode(PostsResponse.self)
                return response
            }
    }
    
    struct PostsCountResponse: ResponseBase {
        var meta: APIMeta
        var data: Int?
    }
    
    static func getCountOfPost(sense: FiveSenses) -> Observable<Int> {
        PostServices.provider
            .rx.request(.getCountOfPost(sense: sense))
            .asObservable()
            .map {
                let response = $0.data.decode(PostsCountResponse.self)
                return response?.data ?? 0
            }
    }
    
    struct CreatePostResponse: ResponseBase {
        var meta: APIMeta
        var data: Post?
    }
    
    static func createPost(creatingPost: CreatingPost) -> Observable<Post?> {
        PostServices.provider
            .rx.request(.createPost(creatingPost: creatingPost))
            .asObservable()
            .map {
                let response = $0.data.decode(CreatePostResponse.self)
                return response?.data
            }
    }
}
