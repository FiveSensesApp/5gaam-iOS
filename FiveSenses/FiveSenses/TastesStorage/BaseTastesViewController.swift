//
//  BaseTastesViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/12.
//

import UIKit

import ESPullToRefresh

class BaseTastesViewController: UIViewController {
    enum Model {
        case header(String)
        case post(Post)
    }
    
    var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tastesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var firstWriteView = FirstWriteView()
    
    var filterCollectionViewFlowLayout: UICollectionViewFlowLayout? {
        didSet {
            if let layout = filterCollectionViewFlowLayout {
                self.filterCollectionView.collectionViewLayout = layout
            }
        }
    }
    
    var tastesCollectionViewFlowLayout: UICollectionViewFlowLayout? {
        didSet {
            if let layout = tastesCollectionViewFlowLayout {
                self.tastesCollectionView.collectionViewLayout = layout
            }
        }
    }
    
    override func loadView() {
        self.view = UIView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(filterCollectionView)
        self.filterCollectionView.then {
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
            $0.register(TastesFilterCell.self, forCellWithReuseIdentifier: TastesFilterCell.identifier)
        }.snp.makeConstraints {
            $0.height.equalTo(60.0)
            $0.left.right.top.equalToSuperview()
        }
        
        self.view.addSubview(tastesCollectionView)
        self.tastesCollectionView.then {
            $0.register(TastesTotalCountHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TastesTotalCountHeaderView.identifier)
            $0.register(ContentTastesCell.self, forCellWithReuseIdentifier: ContentTastesCell.identifier)
        }.snp.makeConstraints {
            $0.top.equalTo(self.filterCollectionView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        self.view.addSubview(firstWriteView)
        self.firstWriteView.snp.makeConstraints {
            $0.top.equalTo(self.filterCollectionView.snp.bottom).offset(9.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(388.0)
        }
        
//        showWritingManual()
    }
    
    func showWritingManual() {
        // TODO: 1회 클릭 후 뜨지 않도록
        let view = UIView().then {
            $0.backgroundColor = .black
            $0.makeCornerRadius(radius: 22.5)
        }
        let label = UILabel().then {
            $0.text = "어떻게 쓰는지 모르겠다면? 👋"
            $0.font = .bold(16.0)
            $0.textAlignment = .center
            $0.textColor = .white
        }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.left.right.centerY.equalToSuperview()
        }
        
        self.view.addSubview(view)
        view.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(38.0)
            $0.width.equalTo(259.0)
            $0.height.equalTo(44.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setFirstWriteView(userNickname: String) {
        let userNickname = NSMutableAttributedString(string: userNickname, attributes: [.font: UIFont.bold(20.0), .foregroundColor: UIColor.gray04])
        
        userNickname.append((self.firstWriteView.titleLabel.attributedText ?? NSMutableAttributedString()))
        self.firstWriteView.titleLabel.attributedText = userNickname
    }
}

final class TastesFilterCell: UICollectionViewCell {
    static let identifier = "TastesFilterCell"
    
    var titleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = .black
            } else {
                self.contentView.backgroundColor = .gray03
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(16.0)
            $0.textColor = .white
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        self.contentView.makeCornerRadius(radius: 18.0)
        self.contentView.backgroundColor = .gray03
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TastesTotalCountHeaderView: UICollectionReusableView {
    static let identifier = "TastesTotalCountHeaderView"
    
    var totalCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(totalCountLabel)
        self.totalCountLabel.then {
            $0.font = .bold(12.0)
            $0.textColor = .black
            $0.text = "총 0개"
        }.snp.makeConstraints {
            $0.height.equalTo(12.0)
            $0.left.equalToSuperview().inset(30.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
