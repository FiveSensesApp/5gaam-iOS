//
//  ContentTastesCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/16.
//

import UIKit

class ContentTastesCell: UICollectionViewCell {
    static let identifier = "ContentTastesCell"
    
    var menuButton = BaseButton()
    var senseImageView = UIImageView()
    var keywordLabel = UILabel()
    var contentLabel = PaddingLabel(padding: UIEdgeInsets(top: 14.0, left: 14.0, bottom: 14.0, right: 14.0))
    var dateLabel = UILabel()
    var starView = ContentTastesStarView()
    
    var tastePost: TastePost!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .gray01
        self.contentView.makeCornerRadius(radius: 12.0)
        
        self.contentView.addSubview(menuButton)
        self.menuButton.then {
            $0.setImage(UIImage(named: "메뉴(공유,수정,삭제)"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.right.equalToSuperview()
            $0.top.equalToSuperview().inset(14.0)
        }
        
        self.contentView.addSubview(senseImageView)
        self.senseImageView.then {
            $0.contentMode = .scaleAspectFill
        }.snp.makeConstraints {
            $0.width.height.equalTo(66.0)
            $0.left.equalToSuperview().inset(14.0)
            $0.top.equalToSuperview().inset(57.0)
        }
        
        let keywordBackgroundImageView = UIImageView(image: UIImage(named: "키워드배경"))
        self.contentView.addSubview(keywordBackgroundImageView)
        keywordBackgroundImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(14.0)
            $0.height.equalTo(48.0)
            $0.left.equalTo(self.senseImageView.snp.right).offset(-6.0)
            $0.centerY.equalTo(self.senseImageView)
        }
        
        self.contentView.addSubview(keywordLabel)
        self.keywordLabel.then {
            $0.font = .bold(16.0)
            $0.textColor = .black
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.right.centerY.equalTo(keywordBackgroundImageView)
            $0.left.equalTo(keywordBackgroundImageView).inset(14.0)
        }
        
        self.contentView.addSubview(contentLabel)
        self.contentLabel.then {
            $0.backgroundColor = .white
            $0.makeCornerRadius(radius: 10.0)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .gray04
            $0.font = .medium(14.0)
        }.snp.makeConstraints {
            $0.height.equalTo(134.0)
            $0.left.right.equalToSuperview().inset(14.0)
            $0.top.equalTo(self.senseImageView.snp.bottom).offset(8.0)
        }
        
        self.contentView.addSubview(dateLabel)
        self.dateLabel.then {
            $0.font = .medium(14.0)
        }.snp.makeConstraints {
            $0.height.equalTo(20.0)
            $0.left.equalToSuperview().inset(24.0)
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(18.0)
        }
        
        self.contentView.addSubview(starView)
        self.starView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(18.0)
            $0.height.equalTo(34.0)
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(10.0)
            $0.bottom.equalToSuperview().inset(26.0)
        }
    }
    
    func configure(tastePost: TastePost) {
        self.tastePost = tastePost
        
        self.menuButton.setImage(UIImage(named: "메뉴(공유,수정,삭제)")?.withTintColor(tastePost.sense.color), for: .normal)
        self.senseImageView.image = tastePost.sense.characterImage
        self.dateLabel.textColor = tastePost.sense.color
        self.dateLabel.text = tastePost.createdDate.toString(format: .WriteView)
        self.starView.setStar(score: tastePost.star, sense: tastePost.sense)
        
        self.keywordLabel.text = tastePost.keyword
        self.contentLabel.text = tastePost.content
        
        if tastePost.content.isNilOrEmpty {
            self.contentLabel.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            self.contentLabel.snp.updateConstraints {
                $0.height.equalTo(134.0)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ContentTastesStarView: UIStackView {
    var score: Int = 0
    
    var starImageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .horizontal
        self.spacing = 7.0
        self.distribution = .fillEqually
        
        self.layoutMargins = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        self.isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStar(score: Int, sense: FiveSenses) {
        
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for _ in 0..<score {
            let star = UIImageView().then {
                $0.image = sense.star(isEmpty: false)
                $0.contentMode = .scaleAspectFit
            }
            self.addArrangedSubview(star)
        }
        
        for _ in score..<5 {
            let border = UIImageView().then {
                $0.image = UIImage(named: "별점테두리")?.withTintColor(sense.color)
                $0.contentMode = .scaleAspectFit
            }
            self.addArrangedSubview(border)
        }
    }
}
