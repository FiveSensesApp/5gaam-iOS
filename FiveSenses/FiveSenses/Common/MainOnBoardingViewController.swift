//
//  MainOnBoardingViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/03/05.
//

import UIKit

import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class MainOnBoardingViewController: UIViewController {
    private var imageView = UIImageView()
    private var progressView = UIView()
    private var skipButton = UIButton()
    private var nextButton = UIButton()
    private var startButton = UIButton()
    
    private var progress = 0
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = UIView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.progressView)
        self.progressView.then {
            $0.backgroundColor = .red02
        }.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(2.0)
            $0.width.equalTo(Constants.DeviceWidth / 3.0)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(101.0)
        }
        
        self.view.addSubview(self.skipButton)
        self.skipButton.then {
            $0.backgroundColor = .gray03
            $0.setTitle("건너뛰기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.makeCornerRadius(radius: 22.0)
        }.snp.makeConstraints {
            $0.width.equalTo(124.0)
            $0.height.equalTo(44.0)
            $0.left.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.progressView.snp.bottom).offset(40.5)
        }
        
        self.view.addSubview(self.nextButton)
        self.nextButton.then {
            $0.backgroundColor = .black
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.makeCornerRadius(radius: 22.0)
        }.snp.makeConstraints {
            $0.width.equalTo(85.0)
            $0.height.equalTo(44.0)
            $0.right.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.progressView.snp.bottom).offset(40.5)
        }
        
        self.view.addSubview(self.imageView)
        self.imageView.then {
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage(named: "Onboarding\(self.progress + 1)")
        }.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(0)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(self.progressView.snp.top)
        }
        
        self.view.addSubview(self.startButton)
        self.startButton.then {
            $0.backgroundColor = .black
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.makeCornerRadius(radius: 22.0)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.width.equalTo(161.0)
            $0.height.equalTo(44.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(98.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                
                self.progress += 1
                
                if self.progress == 3 {
                    self.progressView.isHidden = true
                    self.nextButton.isHidden = true
                    self.skipButton.isHidden = true
                }
                
                UIView.animate(
                    withDuration: 1.0,
                    animations: { [weak self] in
                        guard let self else { return }
                        
                        self.imageView.snp.updateConstraints {
                            $0.centerX.equalToSuperview().offset(-75.0)
                        }
                        self.progressView.snp.updateConstraints {
                            $0.width.equalTo(Constants.DeviceWidth * (CGFloat(self.progress + 1) / 3.0))
                        }
                        self.imageView.alpha = 0.3
                        self.view.layoutIfNeeded()
                    },
                    completion: { [weak self] _ in
                        guard let self else { return }
                        
                        self.imageView.snp.updateConstraints {
                            $0.centerX.equalToSuperview().offset(0.0)
                        }
                        self.imageView.alpha = 1.0
                        self.imageView.image = UIImage(named: "Onboarding\(self.progress + 1)")
                        
                        if self.progress == 3 {
                            self.startButton.isHidden = false
                        }
                    }
                )
            }
            .disposed(by: self.disposeBag)
        
        Observable.merge(self.startButton.rx.tap.asObservable(), self.skipButton.rx.tap.asObservable())
            .bind {
                // TODO: 제거 Defaults[\.didSeenNewOnBoarding] = true
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.replaceRootViewController(MainViewController.makeMainViewController(), animated: true, completion: nil)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
