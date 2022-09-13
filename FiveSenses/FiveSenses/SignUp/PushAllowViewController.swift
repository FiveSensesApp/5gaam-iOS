//
//  PushAllowViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/13.
//

import UIKit

import RxSwift
import RxCocoa

class PushAllowViewController: SignUpBaseViewController {
    var imageView = UIImageView()
    var nextButton = BaseButton()
    
    override func loadView() {
        super.loadView()
        
        self.progress = 4
        self.title = "꾸준하게 기록해보세요."
        self.subtitle = "알림을 허용해주세요. 필요없는 알림은 보내지 않을게요!"
        self.navigationBarView.nextButton.isHidden = true
        
        self.contentView.addSubview(imageView)
        self.imageView.then {
            $0.image = UIImage(named: "알림설정 일러스트")
        }.snp.makeConstraints {
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(15.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(self.imageView.snp.width).multipliedBy(1.023)
        }
        
        self.contentView.addSubview(nextButton)
        self.nextButton.then {
            $0.backgroundColor = .black
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .normal)
            $0.makeCornerRadius(radius: 23.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(189.0)
            $0.height.equalTo(46.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextButton.rx.tap
            .flatMap { [weak self] _ -> Observable<AuthServices.CreateUserResponse?> in
                
                guard let self = self else { return Observable.just(nil) }
                
                if self.title == "꾸준하게 기록해보세요." {
                    self.title = "바로 써볼까요?"
                    self.subtitle = "가입이 완료되었어요. 나만의 취향을 감각해보세요!"
                    self.nextButton.setTitle("시작하기", for: .normal)
                    self.imageView.image = UIImage(named: "시작하기 일러스트")
                    return Observable.just(nil)
                } else {
                    EmailPasswordViewController.creatingUser.isAlarmOn = false
                    
                    return AuthServices.createUser(creatingUser: EmailPasswordViewController.creatingUser)
                }
            }
            .bind {
                guard let response = $0 else { return }
                
                Constants.CurrentUser = response.data
                
                UIApplication.shared.keyWindow?.replaceRootViewController(MainViewController.makeMainViewController(), animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
