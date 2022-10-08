//
//  ContentTastesCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/16.
//

import UIKit

import RxSwift

class ContentTastesCell: UICollectionViewCell {
    static let identifier = "ContentTastesCell"
    var tastePost: Post!
    var tastesView = ContentTastesView()
    var disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .gray01
        self.contentView.makeCornerRadius(radius: 12.0)
        
        self.contentView.addSubview(tastesView)
        tastesView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configure(tastePost: Post) {
        self.tastePost = tastePost
        
        self.tastesView.menuButton.setImage(UIImage(named: "메뉴(공유,수정,삭제)")?.withTintColor(tastePost.category.color), for: .normal)
        self.tastesView.senseImageView.image = tastePost.category.characterImage
        self.tastesView.dateLabel.textColor = tastePost.category.color
        self.tastesView.dateLabel.text = tastePost.createdDate.toString(format: .WriteView)
        self.tastesView.starView.setStar(score: tastePost.star, sense: tastePost.category)
        
        self.tastesView.keywordLabel.text = tastePost.keyword
        self.tastesView.contentTextView.text = tastePost.content
        
        if tastePost.content == "" {
            self.tastesView.contentTextView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            self.tastesView.contentTextView.snp.updateConstraints {
                $0.height.equalTo(134.0)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
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
