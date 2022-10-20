//
//  PostCountGraphView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

enum PostCountType {
    case daily
    case monthly
}

final class PostCountGraphView: UIView {
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var dailyMonthlySwitch = DailyMonthlySwitchView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(18.0)
            $0.textColor = .black
            $0.text = "기록 갯수 추이"
        }.snp.makeConstraints {
            $0.top.equalTo(20.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22.0)
        }
        
        self.addSubview(subTitleLabel)
        self.subTitleLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray04
            $0.text = "기록한 키워드 갯수의 추이를 볼 수 있어요."
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            $0.height.equalTo(14.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(dailyMonthlySwitch)
        self.dailyMonthlySwitch.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(16.0)
            $0.left.right.equalToSuperview().inset(15.0)
            $0.height.equalTo(45.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
