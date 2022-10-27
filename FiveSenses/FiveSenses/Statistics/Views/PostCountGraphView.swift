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

    var graphColletionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var viewModel: StatViewModel?
    
    var emptyImageView = UIImageView()
    
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
        }
        
        self.addSubview(graphColletionView)
        self.graphColletionView.then {
            $0.register(PostCountGraph.self, forCellWithReuseIdentifier: PostCountGraph.identifier)
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                $0.itemSize = CGSize(width: 40.0, height: 235.0 - 11.0)
                $0.minimumInteritemSpacing = 2.0
            }
            $0.isScrollEnabled = false
        
        }.snp.makeConstraints {
            $0.top.equalTo(self.dailyMonthlySwitch.snp.bottom).offset(8.0)
            $0.height.equalTo(235.0)
            $0.left.right.bottom.equalToSuperview().inset(15.0)
        }
        
        self.addSubview(emptyImageView)
        self.emptyImageView.then {
            $0.image = UIImage(named: "Empty기록 갯수 추이")
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PostCountGraph: UICollectionViewCell {
    static let identifier = "PostCountGraph"
    
    private var graphBackgroundView = UIImageView()
    var isPrime = false {
        didSet {
            if isPrime {
                print("@@@@@@!@#!#")
                self.titleLabel.textColor = .black
                self.graphImageView.image = UIImage(named: "갯수 막대Prime")
                self.countBadge.isHidden = false
            } else {
                self.titleLabel.textColor = .gray04
                self.graphImageView.image = UIImage(named: "갯수 막대Normal")
                self.countBadge.isHidden = true
            }
            
        }
    }
    var graphImageView = UIImageView()
    var titleLabel = UILabel()
    var countBadge = UIView()
    var countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.snp.makeConstraints {
            $0.width.equalTo(40.0)
        }
        
        self.addSubview(countBadge)
        self.countBadge.then {
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(27.0)
        }
        
        let imageView = UIImageView()
        self.countBadge.addSubview(imageView)
        imageView.then {
            $0.image = UIImage(named: "갯수 말풍선")
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.countBadge.addSubview(countLabel)
        self.countLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .white
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(3.0)
            $0.height.equalTo(18.0)
        }
        
        self.addSubview(graphBackgroundView)
        self.graphBackgroundView.then {
            $0.image = UIImage(named: "갯수 막대Empty")
            $0.makeCornerRadius(radius: 8.0)
        }.snp.makeConstraints {
            $0.top.equalTo(countBadge.snp.bottom).offset(5.0)
            $0.left.right.equalToSuperview().inset(12.0)
            $0.height.equalTo(165.0)
        }
        
        self.addSubview(graphImageView)
        self.graphImageView.then {
            $0.image = UIImage(named: "갯수 막대Normal")
        }.snp.makeConstraints {
            $0.left.right.bottom.equalTo(self.graphBackgroundView)
            $0.height.equalTo(0.0)
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray04
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(15.0)
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.isPrime = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
