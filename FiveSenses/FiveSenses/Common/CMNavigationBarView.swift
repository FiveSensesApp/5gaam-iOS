//
//  CMNavigationBarView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/11.
//

import UIKit

final class CMNavigationBarView: UIView {
    var rightButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
    }
    var titleView = UIView() {
        didSet {
            self.addSubview(titleView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(rightButton)
        self.rightButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.right.equalToSuperview().inset(22.0)
            $0.top.equalToSuperview().inset(46.0)
        }
        self.addSubview(titleView)
        self.titleView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(20.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
