//
//  TastesStorageViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/11.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class TastesStorageViewController: CMViewController {
    let titleView = TastesStorageTitleView()
    let tastesContainerView = UIView()
    
    let timeLineViewController = TimeLineViewController()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.rightButton.setImage(UIImage(named: "검색 닫혔을때"), for: .normal)
        self.navigationBarView.titleView = titleView
        self.navigationBarView.titleView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(20.0)
            $0.height.equalTo(44.0)
        }
        
        self.contentView.addSubview(tastesContainerView)
        self.tastesContainerView.then {
            $0.backgroundColor = .red
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addChild(timeLineViewController)
        self.tastesContainerView.addSubview(timeLineViewController.view)
        self.timeLineViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.timeLineViewController.didMove(toParent: self)
        
        self.titleView.arrowImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.timeLineViewController.toggleMenu(buttonView: self.titleView.arrowImageView)
                UIView.animate(withDuration: 0.1) {
                    self.titleView.arrowImageView.transform = self.titleView.arrowImageView.transform.rotated(by: .pi)
                }
            }
            .disposed(by: self.disposeBag)
    }
}

final class TastesStorageTitleView: UIView {
    var titleLabel = UILabel()
    var currentFilterLabel = UILabel()
    var arrowImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.text = "나의 취향"
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
        }
        
        self.addSubview(currentFilterLabel)
        self.currentFilterLabel.then {
            $0.text = " | 타임라인"
            $0.font = .bold(26.0)
            $0.textColor = .gray03
        }.snp.makeConstraints {
            $0.left.equalTo(self.titleLabel.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(arrowImageView)
        self.arrowImageView.then {
            $0.image = UIImage(named: "토글")
        }.snp.makeConstraints {
            $0.left.equalTo(self.currentFilterLabel.snp.right)
            $0.right.centerY.equalToSuperview()
            $0.width.height.equalTo(44.0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
