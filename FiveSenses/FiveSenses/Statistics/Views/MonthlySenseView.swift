//
//  MonthlySenseView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/17.
//

import UIKit

final class MonthlySenseView: UIView {
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var thisMonthSenseImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(18.0)
            $0.textColor = .black
            $0.text = "이 달의 감각"
        }.snp.makeConstraints {
            $0.top.equalTo(20.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22.0)
        }
        
        self.addSubview(subTitleLabel)
        self.subTitleLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray04
            $0.text = "월 별로 가장 많이 기록한 감각을 볼 수 있어요."
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            $0.height.equalTo(14.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(thisMonthSenseImageView)
        self.thisMonthSenseImageView.then {
            $0.image = FiveSenses.hearing.monthlyCharacterImage
        }.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(15.0)
            $0.left.right.equalToSuperview().inset(44.5)
            $0.height.equalTo(self.thisMonthSenseImageView.snp.width).multipliedBy(134.0 / 246.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
