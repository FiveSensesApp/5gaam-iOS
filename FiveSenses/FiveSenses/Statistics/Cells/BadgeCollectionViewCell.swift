//
//  BadgeCollectionViewCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/10.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    static let identifier = "BadgeCollectionViewCell"
    
    var badgeImageView = UIImageView()
    var badgeTitleLabel = UILabel()
    var newIndicatorImageView = UIImageView()
    
    var badge: Badge? {
        didSet {
            if let badge = badge {
                self.badgeImageView.kf.setImage(with: URL(string: badge.imgUrl), options: [.processor(SVGProcessor())])
                self.badgeTitleLabel.text = badge.name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(badgeImageView)
        self.badgeImageView.snp.makeConstraints {
            $0.width.height.equalTo(84.0)
            $0.top.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(badgeTitleLabel)
        self.badgeTitleLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(21.0)
            $0.top.equalTo(self.badgeImageView.snp.bottom).offset(10.0)
        }
        
        self.contentView.addSubview(newIndicatorImageView)
        self.newIndicatorImageView.then {
            $0.image = UIImage(named: "신규 획득 알림")
        }.snp.makeConstraints {
            $0.width.height.equalTo(6.0)
            $0.top.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
