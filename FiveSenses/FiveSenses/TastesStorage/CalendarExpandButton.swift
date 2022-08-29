//
//  CalendarExpandButton.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/29.
//

import UIKit

class CalendarExpandButton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "펼치기 버튼"))
        self.addSubview(imageView)
        imageView.then {
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(46.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
