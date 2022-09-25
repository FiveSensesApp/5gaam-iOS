//
//  RefreshFooterView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/25.
//

import UIKit
import ESPullToRefresh
import Lottie

class RefreshFooterView: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    public let loadingMoreDescription: String = "Loading more"
    public let noMoreDataDescription: String  = "No more data"
    public let loadingDescription: String     = "Loading..."
    
    public var view: UIView {
        return self
    }
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 48.0
    public var executeIncremental: CGFloat = 48.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    var loadingAnimationView = AnimationView(name: "Loading5gaam").then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(loadingAnimationView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        self.loadingAnimationView.play()
        self.loadingAnimationView.isHidden = false
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        self.loadingAnimationView.stop()
        self.loadingAnimationView.isHidden = true
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        self.loadingAnimationView.frame = CGRect(x: 0, y: -15.0, width: w, height: h)
    }
    
}

