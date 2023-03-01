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
    let senseViewController = SenseViewController()
    let scoreViewController = ScoreViewController()
    let calendarViewController = CalendarViewController()
    
    var disposeBag = DisposeBag()
    
    var tastesCategoryChoiceMenuView = TastesCategoryChoiceMenuView()
    var maskView = UIView()
    var isMenuDropped = false
    
    var firstViewBackgroundView = UIView()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.rightButton.setImage(UIImage(named: "검색 닫혔을때"), for: .normal)
        self.navigationBarView.titleView = titleView
        self.navigationBarView.titleView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(20.0)
            $0.height.equalTo(44.0)
        }
        
        self.navigationBarView.addSubview(firstViewBackgroundView)
        self.firstViewBackgroundView.then {
            $0.backgroundColor = .white.withAlphaComponent(0.8)
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(tastesContainerView)
        self.tastesContainerView.then {
            $0.backgroundColor = .red
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addChild(calendarViewController)
        self.tastesContainerView.addSubview(calendarViewController.view)
        self.calendarViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.calendarViewController.didMove(toParent: self)
        
        self.addChild(scoreViewController)
        self.tastesContainerView.addSubview(scoreViewController.view)
        self.scoreViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.scoreViewController.didMove(toParent: self)
        
        self.addChild(senseViewController)
        self.tastesContainerView.addSubview(senseViewController.view)
        self.senseViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.senseViewController.didMove(toParent: self)
        
        self.addChild(timeLineViewController)
        timeLineViewController.parentVC = self
        self.tastesContainerView.addSubview(timeLineViewController.view)
        self.timeLineViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.timeLineViewController.didMove(toParent: self)
        
        self.contentView.addSubview(maskView)
        self.maskView.then {
            $0.backgroundColor = .white.withAlphaComponent(0.5)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(tastesCategoryChoiceMenuView)
        self.tastesCategoryChoiceMenuView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(4.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tastesCategoryChoiceMenuView.currentType = .timeLine
        
        self.titleView.arrowImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.toggleMenu(buttonView: self.titleView.arrowImageView, titleView: self.titleView)
                UIView.animate(withDuration: 0.1) {
                    self.titleView.arrowImageView.transform = self.titleView.arrowImageView.transform.rotated(by: .pi)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.tastesCategoryChoiceMenuView.modeViews
            .forEach { modeView in
                modeView.rx.tapGesture()
                    .when(.recognized)
                    .bind { [weak self] _ in
                        self?.setCurrentViewController(type: modeView.type)
                    }
                    .disposed(by: disposeBag)
            }
        
        self.navigationBarView.rightButton
            .rx.tap
            .bind { [weak self] in
                guard let self else { return }
                
                self.navigationController?.pushViewController(SearchPostViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        self.tastesCategoryChoiceMenuView.bottomView
            .rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                if let self = self {
                    self.toggleMenu(buttonView: self.titleView.arrowImageView, titleView: self.titleView)
                    UIView.animate(withDuration: 0.1) {
                        self.titleView.arrowImageView.transform = self.titleView.arrowImageView.transform.rotated(by: .pi)
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setCurrentViewController(type: StorageType) {
        self.timeLineViewController.view.isHidden = true
        self.senseViewController.view.isHidden = true
        self.scoreViewController.view.isHidden = true
        self.calendarViewController.view.isHidden = true
        
        self.tastesCategoryChoiceMenuView.currentType = type
        self.titleView.currentFilterLabel.text = " | \(type.rawValue)"
        
        self.toggleMenu(buttonView: self.titleView.arrowImageView, titleView: self.titleView)
        UIView.animate(withDuration: 0.1) {
            self.titleView.arrowImageView.transform = self.titleView.arrowImageView.transform.rotated(by: .pi)
        }
        
        switch type {
        case .timeLine:
            self.timeLineViewController.view.isHidden = false
        case .senses:
            self.senseViewController.view.isHidden = false
        case .score:
            self.scoreViewController.view.isHidden = false
        case .calendar:
            self.calendarViewController.view.isHidden = false
        }
    }
    
    private func toggleMenu(buttonView: UIView, titleView: TastesStorageTitleView) {
        buttonView.isUserInteractionEnabled = false
        self.maskView.isHidden = self.isMenuDropped
        
        if !self.isMenuDropped {
            titleView.titleLabel.textColor = .gray03
            self.tastesCategoryChoiceMenuView.snp.remakeConstraints {
                $0.top.equalTo(navigationBarView.snp.bottom).offset(4.0)
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            self.tastesCategoryChoiceMenuView.addShadow(location: .bottom, color: .lightGray, opacity: 0.1, radius: 1.0)
        } else {
            titleView.titleLabel.textColor = .black
            self.tastesCategoryChoiceMenuView.snp.remakeConstraints {
                $0.top.equalTo(navigationBarView.snp.bottom).offset(4.0)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(0)
            }
            self.tastesCategoryChoiceMenuView.layer.shadowColor = UIColor.clear.cgColor
        }
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            
            self.view.layoutIfNeeded()
        }) { _ in
            self.isMenuDropped.toggle()
            buttonView.isUserInteractionEnabled = true
        }
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
