//
//  KeywordTastesCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/22.
//

import UIKit

class KeywordTastesCell: UICollectionViewCell {
    var keywordLabel = UILabel()
    var senseImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.makeCornerRadius(radius: 12.0)
        
        self.contentView.addSubview(senseImageView)
        self.senseImageView.then {
            $0.contentMode = .scaleAspectFill
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(keywordLabel)
        self.keywordLabel.then {
            $0.textColor = .black
            $0.font = .bold(16.0)
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(22.0)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func configure(post: TastePost) {
        self.keywordLabel.text = post.keyword
        self.senseImageView.image = post.sense.barImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
