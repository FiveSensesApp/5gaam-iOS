//
//  TastesCategoryChoiceMenuView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/12.
//

import UIKit

final class TastesCategoryChoiceMenuView: UIView {
    var lineView = UIView()
    var categoryStackView = UIStackView()
    var senseView = TastesCategoryView(image: UIImage(named: "토글) 감각"), title: "감각별")
    var scoreView = TastesCategoryView(image: UIImage(named: "토글) 별점별"), title: "점수별")
    var calendarView = TastesCategoryView(image: UIImage(named: "토글) 달력별"), title: "달력별")
    
    private var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(lineView)
        self.lineView.then {
            $0.backgroundColor = .gray03
        }.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(1.0)
        }
        
        self.categoryStackView.addArrangedSubview(senseView)
        self.categoryStackView.addArrangedSubview(scoreView)
        self.categoryStackView.addArrangedSubview(calendarView)
        
        self.addSubview(categoryStackView)
        self.categoryStackView.then {
            $0.axis = .vertical
            $0.spacing = 8.0
            $0.layoutMargins = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 12.0, right: 20.0)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.top.equalTo(self.lineView.snp.bottom).offset(7.0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.categoryStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TastesCategoryView: UIView {
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    convenience init(image: UIImage?, title: String) {
        self.init(frame: .zero)
        
        self.addSubview(self.imageView)
        self.imageView.then {
            $0.image = image
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(72.0)
            $0.width.height.equalTo(24.0)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.text = " | \(title)"
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalTo(self.imageView.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(44.0)
        }
    }
}
