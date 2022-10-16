//
//  BannerPagerCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/16.
//

import UIKit

import FSPagerView

final class BannerPagerCell: FSPagerViewCell {
    static let identifier = "BannerPagerCell"
    
    var bannerImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .gray01
        
        self.contentView.addSubview(bannerImageView)
        self.bannerImageView.then {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
}
