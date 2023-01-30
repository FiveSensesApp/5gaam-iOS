//
//  RecentSearchTextCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/29.
//

import UIKit

import RxSwift

struct RecentSearchTextIdentifier: Hashable {
    var text: String
    var id: Int
}

final class RecentSearchTextCell: UICollectionViewCell {
    static let identifier = "RecentSearchTextCell"
    
    var textLabel = UILabel()
    var deleteButton = BaseButton()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(textLabel)
        self.textLabel.then {
            $0.font = .medium(16.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(30.0)
            $0.top.bottom.equalToSuperview().inset(12.5)
            $0.right.equalToSuperview().inset(60.0)
        }
        
        self.contentView.addSubview(deleteButton)
        self.deleteButton.then {
            $0.setImage(UIImage(named: "닫기_gray"), for: .normal)
            $0.tintColor = .gray03
        }.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.right.equalToSuperview().inset(30.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
