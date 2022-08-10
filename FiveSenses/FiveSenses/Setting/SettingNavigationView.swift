//
//  SettingNavigationView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/20.
//

import UIKit

import Then
import SnapKit

class SettingNavigationView: UIView {
    static let height = 162.0
    
    var backButton = UIButton()
    var titleLabel = UILabel()
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(backButton)
        self.backButton.then {
            $0.setImage(UIImage(named: "뒤로가기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview().inset(44.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(21.0)
            $0.top.equalTo(self.backButton.snp.bottom).offset(25.0)
            $0.bottom.equalToSuperview().inset(24.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
