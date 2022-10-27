//
//  WriteCategorySelectView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/14.
//

import UIKit

final class WriteCategorySelectView: UIView {
    var dateLabel = UILabel()
    var titleLabel = UILabel()
    var copyLabel = UILabel()
    
    var sightButton = WriteToSenseButtonView(image: UIImage(named: "시각 캐릭터"), title: "시각", color: .red03)
    var hearingButton = WriteToSenseButtonView(image: UIImage(named: "청각 캐릭터"), title: "청각", color: .blue03)
    var smellButton = WriteToSenseButtonView(image: UIImage(named: "후각 캐릭터"), title: "후각", color: .green03)
    var tasteButton = WriteToSenseButtonView(image: UIImage(named: "미각 캐릭터"), title: "미각", color: .yellow02)
    var touchButton = WriteToSenseButtonView(image: UIImage(named: "촉각 캐릭터"), title: "촉각", color: .purple03)
    var dontKnowButton = WriteToSenseButtonView(image: UIImage(named: "모르겠어요 캐릭터"), title: "모르겠어요", color: .gray04)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(dateLabel)
        self.dateLabel.then {
            $0.font = .bold(16.0)
            $0.textColor = .gray02
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35.0)
            $0.left.equalToSuperview().inset(34.0)
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.textAlignment = .left
            let string = NSMutableAttributedString(string: "\(Constants.CurrentUser?.nickname ?? "")님의 취향,\n어떤 감각으로 기록할까요?", attributes: [.font: UIFont.bold(26.0), .foregroundColor: UIColor.black])
            $0.attributedText = string
            $0.numberOfLines = 2
        }.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(22.0)
            $0.left.equalToSuperview().inset(34.0)
        }
        
        let horizontalStackView1 = UIStackView(arrangedSubviews: [self.sightButton, self.hearingButton, self.smellButton]).then {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.distribution = .fillEqually
        }
        
        let horizontalStackView2 = UIStackView(arrangedSubviews: [self.tasteButton, self.touchButton, self.dontKnowButton]).then {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.distribution = .fillEqually
        }
        
        let stackView = UIStackView(arrangedSubviews: [horizontalStackView1, horizontalStackView2])
        
        self.addSubview(stackView)
        stackView.then {
            $0.axis = .vertical
            $0.spacing = 8.0
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(53.0)
            $0.left.right.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(copyLabel)
        self.copyLabel.then {
            $0.font = .semiBold(16.0)
            $0.text = Constants.RandomCategorySelectCopyString
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
