//
//  DailyMonthlySwitchView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

class DailyMonthlySwitchView: UIView {
    var dailyButton = UIButton()
    var monthlyButton = UIButton()
    
    var selectedBackgroundView = UIView()
    
    var disposeBag = DisposeBag()
    
    var selectedType = BehaviorRelay<PostCountType>(value: .daily)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray01
        self.makeCornerRadius(radius: 22.5)
        
        self.addSubview(selectedBackgroundView)
        self.selectedBackgroundView.then {
            $0.makeCornerRadius(radius: 18.5)
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(4.0)
            $0.width.equalTo((Constants.DeviceWidth - 78.0) / 2.0)
        }
        
        self.addSubview(dailyButton)
        self.dailyButton.then {
            $0.setTitle("일간", for: .normal)
            $0.titleLabel?.font = .bold(16.0)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .clear
        }.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(monthlyButton)
        self.monthlyButton.then {
            $0.setTitle("월간", for: .normal)
            $0.titleLabel?.font = .bold(16.0)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .clear
        }.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.left.equalTo(self.snp.centerX)
        }
        
        self.dailyButton
            .rx.tap
            .map { PostCountType.daily }
            .bind(to: self.selectedType)
            .disposed(by: disposeBag)
        
        self.monthlyButton
            .rx.tap
            .map { PostCountType.monthly }
            .bind(to: self.selectedType)
            .disposed(by: disposeBag)
        
        self.selectedType
            .bind { [weak self] type in
                guard let self = self else { return }
                
               
                
                
                self.selectedBackgroundView.snp.remakeConstraints {
                    if type == .daily {
                        $0.left.equalToSuperview().inset(4.0)
                    } else {
                        $0.right.equalToSuperview().inset(4.0)
                    }
                    $0.top.bottom.equalToSuperview().inset(4.0)
                    $0.width.equalTo((Constants.DeviceWidth - 78.0) / 2.0)
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.selectedBackgroundView.superview?.layoutIfNeeded()
                }, completion: { _ in
                    switch type {
                    case .daily:
                        self.dailyButton.titleLabel?.font = .bold(16.0)
                        self.dailyButton.setTitleColor(.black, for: .normal)
                        self.monthlyButton.titleLabel?.font = .medium(16.0)
                        self.monthlyButton.setTitleColor(.gray04, for: .normal)
                    case .monthly:
                        self.monthlyButton.titleLabel?.font = .bold(16.0)
                        self.monthlyButton.setTitleColor(.black, for: .normal)
                        self.dailyButton.titleLabel?.font = .medium(16.0)
                        self.dailyButton.setTitleColor(.gray04, for: .normal)
                    }
                })
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
