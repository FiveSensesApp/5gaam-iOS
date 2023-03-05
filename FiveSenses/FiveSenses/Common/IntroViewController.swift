//
//  IntroViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/04.
//

import UIKit

import RxSwift
import Lottie
import SwiftJWT
import SwiftyUserDefaults

class IntroViewController: UIViewController {
    var lottieView = AnimationView(name: "Loading5gaam")
    var copylightImageView = UIImageView()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(lottieView)
        self.lottieView.snp.makeConstraints {
            $0.width.equalTo(225.0)
            $0.height.equalTo(150.0)
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.view.addSubview(copylightImageView)
        self.copylightImageView.then {
            $0.image = UIImage(named: "MANGPO")
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(17.0)
            $0.width.equalTo(63.0)
            $0.height.equalTo(18.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lottieView.play(completion: { [weak self] _ in
            
            guard let self = self else {
                UIApplication.shared.keyWindow?.replaceRootViewController(OnBoardingViewController(), animated: true, completion: nil)
                return
            }
            
            if let string = KeyChainController.shared.read(Constants.ServiceString, account: "Token") {
                Constants.CurrentToken = (try? JWT<TokenContent>(jwtString: string))?.claims
            } else {
                Constants.CurrentToken = nil
            }
            
            self.lottieView.play(completion: { [weak self] _ in
                guard let self else { return }
                
                UserServices.getUserInfo()
                    .observe(on: MainScheduler.asyncInstance)
                    .bind {
                        guard let userInfo = $0 else {
                            UIApplication.shared.keyWindow?.replaceRootViewController(OnBoardingViewController(), animated: true, completion: nil)
                            return
                        }
                        UNUserNotificationCenter.current().delegate = self
                        Constants.CurrentUser = userInfo.createdUser
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] _, _ in
                            guard let self = self else { return }
                            DispatchQueue.main.async {
                                if Defaults[\.didSeenNewOnBoarding] {
                                    UIApplication.shared.keyWindow?.replaceRootViewController(MainViewController.makeMainViewController(), animated: true, completion: nil)
                                } else {
                                    UIApplication.shared.keyWindow?.replaceRootViewController(MainOnBoardingViewController(), animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
        })
    }
}

extension IntroViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
