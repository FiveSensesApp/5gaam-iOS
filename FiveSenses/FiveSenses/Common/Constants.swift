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
}
