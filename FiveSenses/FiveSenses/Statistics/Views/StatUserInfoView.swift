//
//  StatUserInfoView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/16.
//

import UIKit

final class StatUserInfoView: UIView {
    var settingButton = BaseButton()
    var nicknameLabel = UILabel()
    var nicknameChangeButton = BaseButton()
    var emailLabel = UILabel()
    var representBadgeImageView = UIImageView()
    
    private var recordDueImageView = UIImageView()
    private var recordDueLabel = UILabel()
    private var numberOfPostImageView = UIImageView()
    private var numberOfPostLabel = UILabel()
    
    var badgeBackgroundImageView = UIImageView()
    private var badgeTitleLabel = UILabel()
    var moreBadgeButton = BaseButton()
    var badgeStackView = UIStackView()
    
    var recordDue: Int = 0 {
        didSet {
            self.recordDueLabel.text = "기록한지   D+\(recordDue)"
        }
    }
    
    var numberOfPost: Int = 0 {
        didSet {
            self.numberOfPostLabel.text = "기록갯수   \(numberOfPost)개"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(settingButton)
        self.settingButton.then {
            $0.setImage(UIImage(named: "설정 아이콘"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().inset(21.0)
        }
        
        self.addSubview(nicknameLabel)
        self.nicknameLabel.then {
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(98.0)
            $0.left.equalToSuperview().inset(20.0)
            $0.height.equalTo(31.0)
        }
        
        self.addSubview(nicknameChangeButton)
        self.nicknameChangeButton.then {
            $0.setImage(UIImage(named: "수정 아이콘 1"), for: .normal)
        }.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel)
            $0.left.equalTo(self.nicknameLabel.snp.right)
            $0.width.height.equalTo(31.0)
        }
        
        self.addSubview(emailLabel)
        self.emailLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray03
        }.snp.makeConstraints {
            $0.height.equalTo(18.0)
            $0.top.equalTo(self.nicknameLabel.snp.bottom)
            $0.left.equalTo(self.nicknameLabel)
        }
        
        self.addSubview(representBadgeImageView)
        self.representBadgeImageView.then {
            $0.image = UIImage(named: "대표뱃지) 없을 때")
        }.snp.makeConstraints {
            $0.width.height.equalTo(120.0)
            $0.top.equalToSuperview().inset(93.0)
            $0.right.equalToSuperview().inset(20.0)
        }
        
        self.addSubview(recordDueImageView)
        self.recordDueImageView.then {
            $0.image = UIImage(named: "토글) 달력별 1")
        }.snp.makeConstraints {
            $0.top.equalTo(self.emailLabel.snp.bottom).offset(19.0)
            $0.width.height.equalTo(14.0)
            $0.left.equalTo(self.emailLabel)
        }
        
        self.addSubview(recordDueLabel)
        self.recordDueLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.height.equalTo(22.0)
            $0.centerY.equalTo(self.recordDueImageView)
            $0.left.equalTo(self.recordDueImageView.snp.right).offset(5.0)
        }
        
        self.addSubview(numberOfPostImageView)
        self.numberOfPostImageView.then {
            $0.image = UIImage(named: "기록갯수 아이콘")
        }.snp.makeConstraints {
            $0.top.equalTo(self.recordDueImageView.snp.bottom).offset(9.0)
            $0.width.height.equalTo(14.0)
            $0.left.equalTo(self.emailLabel)
        }
        
        self.addSubview(numberOfPostLabel)
        self.numberOfPostLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.height.equalTo(22.0)
            $0.centerY.equalTo(self.numberOfPostImageView)
            $0.left.equalTo(self.numberOfPostImageView.snp.right).offset(5.0)
        }
        
        self.addSubview(badgeBackgroundImageView)
        self.badgeBackgroundImageView.then {
            $0.image = UIImage(named: "획득한 뱃지 bg")
            $0.contentMode = .scaleToFill
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(61.0)
            $0.top.equalTo(self.representBadgeImageView.snp.bottom).offset(22.0)
        }
        
        self.addSubview(badgeTitleLabel)
        self.badgeTitleLabel.then {
            $0.font = .bold(18.0)
            $0.textColor = .black
            $0.text = "획득한 뱃지"
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(39.0)
            $0.top.equalTo(self.badgeBackgroundImageView).offset(20.0)
            $0.height.equalTo(22.0)
        }
        
        self.addSubview(moreBadgeButton)
        self.moreBadgeButton.then {
            $0.setImage(UIImage(named: "뱃지 상세 보러가기"), for: .normal)
        }.snp.makeConstraints {
            $0.top.equalTo(self.badgeBackgroundImageView).offset(8.0)
            $0.right.equalTo(self.badgeBackgroundImageView).inset(3.0)
            $0.width.height.equalTo(44.0)
        }
        
//        self.addSubview(badgeStackView)
//        self.badgeStackView.then {
//            $0.axis = .horizontal
//            $0.spacing = 11.0
//            $0.distribution = .fillEqually
//        }.snp.makeConstraints {
//            $0.top.equalTo(self.badgeTitleLabel.snp.bottom).offset(18.0)
//            $0.left.right.equalTo(self.badgeBackgroundImageView).inset(21.0)
//            $0.bottom.equalTo(self.badgeBackgroundImageView).inset(17.0)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

