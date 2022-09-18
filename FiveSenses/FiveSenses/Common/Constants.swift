//
//  Constants.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/20.
//

import UIKit

class Constants {
    static var DeviewBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    static var DeviceWidth: CGFloat {
        return Constants.DeviewBounds.size.width
    }
    
    static var DeviceHeight: CGFloat {
        return Constants.DeviewBounds.size.height
    }
    
    static var RandomCategorySelectCopyString: String {
        return [
            "감각을 통해 취향을 쌓는 즐거움!",
            "당신은 무엇을 감각할 때 행복한가요?",
            "내가 보고 듣고 느끼는 나만의 취향",
            "감각하며 수집하는 일상 속 취향",
            "오감으로 찾는 나만의 취향",
            "지극히 나다운 취향수집함"
        ].randomElement()!
    }
    
    static let sourceURL = "http://fivesensesserver2-env.eba-2dcamzuq.ap-northeast-2.elasticbeanstalk.com/api"
    
    static let ServiceString = Bundle.main.bundleIdentifier ?? ""
    
    static var CurrentUser: CreatedUser? = nil
    static var CurrentToken: TokenContent? = nil
}

enum StorageType: String {
    case timeLine = "타임라인"
    case senses = "감각별"
    case score = "점수별"
    case calendar = "달력별"
}

enum FiveSenses: Codable, CaseIterable {
    case sight
    case hearing
    case smell
    case taste
    case touch
    case dontKnow
    
    var name: String {
        switch self {
        case .sight:
            return "시각"
        case .hearing:
            return "청각"
        case .smell:
            return "후각"
        case .taste:
            return "미각"
        case .touch:
            return "촉각"
        case .dontKnow:
            return "모르겠어요"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .sight:
            return UIImage(named: "시각")
        case .hearing:
            return UIImage(named: "청각")
        case .smell:
            return UIImage(named: "후각")
        case .taste:
            return UIImage(named: "미각")
        case .touch:
            return UIImage(named: "촉각")
        case .dontKnow:
            return UIImage(named: "모르겠어요")
        }
    }
    
    var characterImage: UIImage? {
        switch self {
        case .sight:
            return UIImage(named: "시각 캐릭터")
        case .hearing:
            return UIImage(named: "청각 캐릭터")
        case .smell:
            return UIImage(named: "후각 캐릭터")
        case .taste:
            return UIImage(named: "미각 캐릭터")
        case .touch:
            return UIImage(named: "촉각 캐릭터")
        case .dontKnow:
            return UIImage(named: "모르겠어요 캐릭터")
        }
    }
    
    var color: UIColor {
        switch self {
        case .sight:
            return .red02
        case .hearing:
            return .blue02
        case .smell:
            return .green02
        case .taste:
            return .yellow02
        case .touch:
            return .purple02
        case .dontKnow:
            return .gray04
        }
    }
    
    var barImage: UIImage? {
        switch self {
        case .sight:
            return UIImage(named: "시각 막대")
        case .hearing:
            return UIImage(named: "청각 막대")
        case .smell:
            return UIImage(named: "후각 막대")
        case .taste:
            return UIImage(named: "미각 막대")
        case .touch:
            return UIImage(named: "촉각 막대")
        case .dontKnow:
            return UIImage(named: "모르겠어요 막대")
        }
    }
    
    var category: String {
        switch self {
        case .sight:
            return "SIGHT"
        case .hearing:
            return "HEARING"
        case .smell:
            return "SMELL"
        case .taste:
            return "TASTE"
        case .touch:
            return "TOUCH"
        case .dontKnow:
            return "AMBIGUOUS"
        }
    }
    
    static func senseByCategory(category: String) -> FiveSenses {
        for sense in FiveSenses.allCases {
            if category == sense.category {
                return sense
            }
        }
        
        return .dontKnow
    }
    
    func star(isEmpty: Bool) -> UIImage? {
        let footer = isEmpty ? " 빈별점" : " 별점"
        return UIImage(named: self.name + footer)
    }
}
