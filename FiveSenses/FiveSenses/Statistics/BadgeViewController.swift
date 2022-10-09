//
//  BadgeViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/10.
//

import UIKit

import RxCocoa
import RxSwift

class BadgeViewController: CMViewController {
    var backButton = BaseButton()
    
    private var disposeBag = DisposeBag()
    
    var representBadgeImageView = UIImageView()
    var representBadgeTitleLabel = UILabel()
    var representBadgeDescriptionLabel = UILabel()
    
    var representBadgeTitle: String = "" {
        didSet {
            let string = NSMutableAttributedString(string: "대표 뱃지 | ", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray04])
            string.append(NSMutableAttributedString(string: representBadgeTitle, attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.black]))
            self.representBadgeTitleLabel.attributedText = string
        }
    }
    
    private var badgeCollectionTitleLabel = UILabel()
    var badgeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var badgeCountLabel = UILabel()
    
    var viewModel = BadgeViewModel()
    
    override func loadView() {
        super.loadView()
        
        self.representBadgeTitle = "비어있어요"
        
        self.navigationBarView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.then {
            $0.backgroundColor = .white
            $0.bounces = false
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentView.removeFromSuperview()
        scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        self.contentView.addSubview(backButton)
        self.backButton.then {
            $0.setImage(UIImage(named: "뒤로가기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview().inset(44.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.contentView.addSubview(representBadgeImageView)
        self.representBadgeImageView.then {
            $0.image = UIImage(named: "대표뱃지) 없을 때")
        }.snp.makeConstraints {
            $0.width.height.equalTo(162.0)
            $0.top.equalToSuperview().inset(64.0)
            $0.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(representBadgeTitleLabel)
        self.representBadgeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.representBadgeImageView.snp.bottom).offset(14.0)
            $0.height.equalTo(19.0)
            $0.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(representBadgeDescriptionLabel)
        self.representBadgeDescriptionLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
            $0.text = "취향을 기록해 대표 뱃지를 설정해보세요!\n획득조건은 미리 볼 수 있어요."
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(self.representBadgeTitleLabel.snp.bottom).offset(7.2)
            $0.centerX.equalToSuperview()
        }
        
        let lineView = UIView()
        
        self.contentView.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray02
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.representBadgeDescriptionLabel.snp.bottom).offset(22.2)
            $0.height.equalTo(1.0)
        }
        
        self.contentView.addSubview(badgeCollectionTitleLabel)
        self.badgeCollectionTitleLabel.then {
            $0.font = .bold(20.0)
            $0.textColor = .black
            $0.text = "획득한 뱃지"
        }.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(25.0)
            $0.left.equalToSuperview().inset(25.0)
            $0.height.equalTo(24.0)
        }
        
        self.contentView.addSubview(badgeCountLabel)
        self.badgeCountLabel.then {
            $0.font = .semiBold(16.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(30.0)
            $0.right.equalToSuperview().inset(25.0)
            $0.height.equalTo(16.0)
        }
        
        self.contentView.addSubview(badgeCollectionView)
        self.badgeCollectionView.then {
            $0.register(BadgeCollectionViewCell.self, forCellWithReuseIdentifier: BadgeCollectionViewCell.identifier)
            $0.backgroundColor = .white
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                // TODO: SE 분기처리
                $0.itemSize = CGSize(width: 84.0, height: 115.0)
                $0.minimumLineSpacing = 27.0
                $0.minimumInteritemSpacing = 20.0
            }
            $0.delegate = self
            $0.dataSource = self
        }.snp.makeConstraints {
            $0.top.equalTo(badgeCountLabel.snp.bottom).offset(32.0)
            $0.left.right.equalToSuperview().inset(41.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(825.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.output!.representBadge
            .bind { [weak self] in
                guard let self = self else { return }
                
                if let badge = $0 {
                    self.representBadgeImageView.kf.setImage(with: URL(string: badge.imgUrl), options: [.processor(SVGProcessor())])
                    self.representBadgeTitle = badge.name
                    self.representBadgeDescriptionLabel.text = "\(badge.description ?? "")/n\(badge.reqCondition ?? "")"
                } else {
                    self.representBadgeTitle = "비어있어요"
                    self.representBadgeImageView.image = UIImage(named: "대표뱃지) 없을 때")
                    self.representBadgeDescriptionLabel.text = "취향을 기록해 대표 뱃지를 설정해보세요!\n획득조건은 미리 볼 수 있어요."
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.output!.badges
            .bind { [weak self] in
                self?.badgeCountLabel.text = "(\($0.count)/16)"
                self?.badgeCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension BadgeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.output!.badges.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeCollectionViewCell.identifier, for: indexPath) as! BadgeCollectionViewCell
        cell.badge = self.viewModel.output!.badges.value[indexPath.item]
        print("@@@@@@@")
        return cell
    }
}
