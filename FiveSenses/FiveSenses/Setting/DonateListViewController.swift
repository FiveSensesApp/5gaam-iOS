//
//  DonateListViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/26.
//

import UIKit

final class DonateListViewController: BaseSettingViewController {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    let donates = [
        "오은비",
        "여련새",
        "마메모",
        "김민정",
        "정혜란",
        "권희아",
        "후하하",
        "dkdo",
        "아그니",
        "임동영",
        "MINJAAAAA",
        "김영훈",
        "ys96****",
        "소라",
        "kennnny",
        "상희",
        "웅냐",
        "주연",
        "청빈",
        "KZNKZN",
        "김은서",
        "임태빈",
        "강민주",
        "담연",
        "도도",
        "노수민",
        "wise",
        "최병현",
        "정준혁",
        "이창민",
        "김상기",
        "안소영",
        "한지희",
        "옴노",
        "백승빈",
        "문호연",
        "우0",
        "권성연",
        "이강현",
        "차준수",
        "현기",
        "유림",
        "안광미",
        "glx",
        "김예지",
        "위수지",
        "김다은",
        "이혜영",
        "뉴뉴",
        "데낙",
        "쪼",
        "홍희주",
        "최혜정",
        "이예린",
        "민지수",
        "박유진",
        "조수빈",
        "고구미",
        "유가은",
        "김상원",
        "RyoT",
        "유진",
        "DAUN KIM",
        "김서연",
        "r_ze",
        "최지헌",
        "김동후",
        "함효희",
        "지수",
        "Lovehippo",
        "solitdo"
    ]
    
    
    var donateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.title = ""
        
        self.view.addSubview(imageView)
        self.imageView.then {
            $0.image = UIImage(named: "Donate")
        }.snp.makeConstraints {
            $0.width.equalTo(238.15)
            $0.height.equalTo(203.0)
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(16.0)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.text = "펀딩부터 출시까지"
        }.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(28.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(19.0)
        }
        
        self.view.addSubview(subtitleLabel)
        self.subtitleLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.text = "떡잎부터 알아봐주신 여러분 덕분에\n‘오감’이 세상 밖으로 나올 수 있었습니다!"
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(6.0)
            $0.left.right.equalToSuperview()
        }
        
        let lineView = UIView()
        self.view.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(22.0)
        }
        
        self.view.addSubview(donateCollectionView)
        self.donateCollectionView.then {
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                let size = (Constants.DeviceWidth - 122.0) / 3.0
                $0.itemSize = CGSize(width: size, height: size)
                $0.minimumLineSpacing = 26.0
                $0.minimumInteritemSpacing = 20.0
            }
            $0.register(DonateCell.self, forCellWithReuseIdentifier: DonateCell.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.allowsSelection = false
            $0.bounces = true
        }.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(26.0)
            $0.left.right.equalToSuperview().inset(41.0)
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
}

extension DonateListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DonateCell.identifier, for: indexPath) as! DonateCell
        
        cell.nameLabel.text = donates[indexPath.item]
        
        return cell
    }
}

final class DonateCell: UICollectionViewCell {
    static let identifier = "DonateCell"
    
    var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .gray01
        self.contentView.makeCornerRadius(radius: (Constants.DeviceWidth - 122.0) / 6.0)
        
        self.contentView.addSubview(nameLabel)
        self.nameLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(15.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
