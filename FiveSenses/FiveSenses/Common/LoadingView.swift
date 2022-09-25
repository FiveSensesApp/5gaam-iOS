//
//  LoadingView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/22.
//

import UIKit

import Lottie
import ESPullToRefresh

class LoadingView: ESRefreshFooterView {

    var loadingView = AnimationView(name: "Loading5gaam")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(loadingView)
        self.loadingView.then {
            $0.loopMode = .loop
        }.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.width.equalTo(90.0)
            $0.height.equalTo(60.0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
