//
//  TimeLineViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/21.
//

import Foundation

class TimeLineViewModel: BaseViewModel {
    struct Input { }
    struct Output {
        var tastePosts: [TastePost] = []
    }
    
    var input: Input?
    var output: Output? = Output()
    
    var mockData = [
        TastePost(id: 61, sense: .touch, keyword: "취향 키워드", star: 2, content: "", createdDate: "2022-08-05T14:54:43.191123".toDate(format: .Server)!, modifiedDate: Date()),
        TastePost(id: 62, sense: .sight, keyword: "취향 키워드", star: 2, content: "취향 컨텐츠 입니다.취향 컨텐츠 입니다.취향 컨텐츠 입니다.취향 컨텐츠 입니다.", createdDate: Date(), modifiedDate: Date()),
        TastePost(id: 63, sense: .dontKnow, keyword: "취향 키워드", star: 2, content: "", createdDate: Date(), modifiedDate: Date()),
        TastePost(id: 64, sense: .smell, keyword: "취향 키워드", star: 2, content: "취향 컨텐츠 입니다.취향 컨텐츠 입니다.취향 컨텐츠 입니다.취향 컨텐츠 입니다.", createdDate: Date(), modifiedDate: Date())
    ]
    
    init() {
        self.output?.tastePosts = self.mockData
    }
    
    func toSections() -> [Section] {
        var items: [Item] = []
        
        for post in self.output?.tastePosts ?? [] {
            items.append(Item(model: TimeLineViewController.Model.post(post), cellType: ContentTastesCell.self))
        }
        
        return [Section(
            header: Header(model: TimeLineViewController.Model.header("2"), viewType: TastesTotalCountHeaderView.self),
            items: items
        )]
    }
}
