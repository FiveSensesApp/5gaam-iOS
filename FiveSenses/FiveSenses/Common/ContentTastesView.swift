//
//  ContentTastesView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/26.
//

import UIKit

class ContentTastesView: UIView {
    var menuButton = BaseButton()
    var senseImageView = UIImageView()
    var keywordLabel = UILabel()
    var contentTextView = UITextView()
    var dateLabel = UILabel()
    var starView = ContentTastesStarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray01
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(menuButton)
        self.menuButton.then {
            $0.setImage(UIImage(named: "메뉴(공유,수정,삭제)"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.right.equalToSuperview()
            $0.top.equalToSuperview().inset(14.0)
        }
        
        self.addSubview(senseImageView)
        self.senseImageView.then {
            $0.contentMode = .scaleAspectFill
        }.snp.makeConstraints {
            $0.width.height.equalTo(66.0)
            $0.left.equalToSuperview().inset(14.0)
            $0.top.equalToSuperview().inset(57.0)
        }
        
        let keywordBackgroundImageView = UIImageView(image: UIImage(named: "키워드배경"))
        self.addSubview(keywordBackgroundImageView)
        keywordBackgroundImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(14.0)
            $0.height.equalTo(48.0)
            $0.left.equalTo(self.senseImageView.snp.right).offset(-6.0)
            $0.centerY.equalTo(self.senseImageView)
        }
        
        self.addSubview(keywordLabel)
        self.keywordLabel.then {
            $0.font = .bold(16.0)
            $0.textColor = .black
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.right.centerY.equalTo(keywordBackgroundImageView)
            $0.left.equalTo(keywordBackgroundImageView).inset(14.0)
        }
        
        self.addSubview(contentTextView)
        self.contentTextView.then {
            $0.backgroundColor = .white
            $0.makeCornerRadius(radius: 10.0)
            $0.textAlignment = .left
            $0.textColor = .gray04
            $0.font = .medium(14.0)
            $0.isUserInteractionEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 14.0, right: 14.0)
        }.snp.makeConstraints {
            $0.height.equalTo(134.0)
            $0.left.right.equalToSuperview().inset(14.0)
            $0.top.equalTo(self.senseImageView.snp.bottom).offset(8.0)
        }
        
        self.addSubview(dateLabel)
        self.dateLabel.then {
            $0.font = .medium(14.0)
        }.snp.makeConstraints {
            $0.height.equalTo(20.0)
            $0.left.equalToSuperview().inset(24.0)
            $0.top.equalTo(self.contentTextView.snp.bottom).offset(18.0)
        }
        
        self.addSubview(starView)
        self.starView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(18.0)
            $0.height.equalTo(34.0)
            $0.top.equalTo(self.contentTextView.snp.bottom).offset(10.0)
            $0.bottom.equalToSuperview().inset(26.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
