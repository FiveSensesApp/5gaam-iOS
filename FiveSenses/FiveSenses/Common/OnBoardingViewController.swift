//
//  OnBoardingViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/04.
//

import UIKit

import RxSwift
import RxCocoa
import SwiftyUserDefaults

class OnBoardingViewController: UIViewController {
    private var currentProgress = BehaviorRelay<Int>(value: Defaults[\.hadSeenOnBoarding] ? 4 : 1)
    
    private var messageLabel = UILabel()
    private var illustImageView = UIImageView()
    private var progressImageView = UIImageView()
    private var nextButton = BaseButton()
    private var loginButton = UILabel()
    
    private let messages: [String] = [
        "당신은 무엇을 감각할 때\n가장 행복한가요?",
        "내가 보고 듣고 느끼는 것이\n곧 나를 이룬다.",
        "사소한 것이라도 괜찮아요.\n하나씩 쌓이면 취향이 됩니다.",
        "오감으로 느낀 당신의 취향을\n지금 수집해보세요."
    ]
    
    private var isFirstLoad = true
    
    private let disposeBag = DisposeBag()
    
    convenience init(progress: Int? = nil) {
        self.init()
        
        if let progress = progress {
            self.currentProgress.accept(progress)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(messageLabel)
        self.messageLabel.then {
            $0.font = .medium(16.0)
            $0.textColor = .gray04
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view).inset(116.0)
        }
        
        self.view.addSubview(illustImageView)
        self.illustImageView.then {
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(self.illustImageView.snp.width).multipliedBy(0.87)
            $0.top.equalTo(self.messageLabel.snp.bottom).offset(40.0)
        }
        
        self.view.addSubview(progressImageView)
        self.progressImageView.then {
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.height.equalTo(5.0)
            $0.width.equalTo(50.0)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.illustImageView.snp.bottom).offset(40.0)
        }
        
        self.view.addSubview(nextButton)
        self.nextButton.then {
            $0.backgroundColor = .black
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.makeCornerRadius(radius: 23.0)
        }.snp.makeConstraints {
            $0.height.equalTo(46.0)
            $0.width.equalTo(189.0)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.progressImageView.snp.bottom).offset(15.0)
        }
        
        self.view.addSubview(loginButton)
        self.loginButton.then {
            let string = NSMutableAttributedString(string: "이미 가입하셨나요? ", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray03])
            string.append(NSMutableAttributedString(string: "로그인하기", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray03, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.gray03]))
            $0.attributedText = string
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(15.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 추후 제거
//        if Defaults[\.hadSeenOnBoarding] {
//            self.currentProgress.accept(4)
//        }
        
        Defaults[\.hadSeenOnBoarding] = true
        
        self.currentProgress
            .take(while: {
                $0 <= 4
            })
            .bind { [weak self] index in
                guard let self = self else { return }
                
                self.progressImageView.image = UIImage(named: "일러스트 순서\(index)")
                
                if self.isFirstLoad {
                    self.illustImageView.image = UIImage(named: "온보딩 일러스트 \(index)")
                    self.messageLabel.text = self.messages[index - 1]
                    self.isFirstLoad = false
                } else {
                    UIView.animate(
                        withDuration: 1.0,
                        animations: {
                            self.illustImageView.snp.remakeConstraints {
                                $0.centerX.equalToSuperview().offset(-75.0)
                                $0.width.equalToSuperview()
                                $0.height.equalTo(self.illustImageView.snp.width).multipliedBy(0.87)
                                $0.top.equalTo(self.messageLabel.snp.bottom).offset(40.0)
                            }
                            self.messageLabel.text = self.messages[index - 1]
                            self.illustImageView.alpha = 0.3
                            self.view.layoutIfNeeded()
                        },
                        completion: { _ in
                            self.illustImageView.snp.remakeConstraints {
                                $0.centerX.equalToSuperview()
                                $0.width.equalToSuperview()
                                $0.height.equalTo(self.illustImageView.snp.width).multipliedBy(0.87)
                                $0.top.equalTo(self.messageLabel.snp.bottom).offset(40.0)
                            }
                            self.illustImageView.alpha = 1.0
                            self.illustImageView.image = UIImage(named: "온보딩 일러스트 \(index)")
                        }
                    )
                }
                
                if index == 4 {
                    self.loginButton.isHidden = false
                    self.nextButton.setTitle("회원가입", for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        self.illustImageView.rx.swipeGesture(.left)
            .when(.recognized)
            .withLatestFrom(self.currentProgress)
            .map { $0 + 1 }
            .bind(to: self.currentProgress)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.tap
            .withLatestFrom(self.currentProgress)
            .map { $0 + 1 }
            .bind { [weak self] in
                guard let self = self else { return }
                
                if $0 >= 5 {
                    let vc = CMNavigationController(rootViewController: EmailPasswordViewController())
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    self.currentProgress.accept($0)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.loginButton.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                let vc = CMNavigationController(rootViewController: LoginViewController())
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
