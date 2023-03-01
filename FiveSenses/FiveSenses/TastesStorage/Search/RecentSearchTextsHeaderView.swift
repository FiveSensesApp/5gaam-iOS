//
//  RecentSearchTextsHeaderView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/29.
//

import UIKit

final class RecentSearchTextsHeaderView: UIView {
    private var titleLabel = UILabel()
    var deleteAllButton = BaseButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .semiBold(12.0)
            $0.text = "최근 검색어"
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(deleteAllButton)
        self.deleteAllButton.then {
            $0.setTitle("전체 삭제", for: .normal)
            $0.setTitleColor(.red02, for: .normal)
            $0.titleLabel?.font = .medium(12.0)
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
