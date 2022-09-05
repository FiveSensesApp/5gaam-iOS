//
//  IntroViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/04.
//

import UIKit
import Lottie

class IntroViewController: UIViewController {
    var lottieView = AnimationView(name: "Loading5gaam")
    var copylightImageView = UIImageView()
    
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
        
        let mainViewController = MainViewController()
        let vc1 = TastesStorageViewController().then {
            $0.view.backgroundColor = .white
            $0.tabBarItem.image = UIImage(named: "보관함 아이콘")
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
        }
        let vc2 = UIViewController()
        let vc3 = SettingViewController().then {
            $0.tabBarItem.image = UIImage(named: "성향분석 아이콘")
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
        }
        mainViewController.viewControllers = [vc1, vc2, vc3]
        
        self.lottieView.play(completion: { [weak self] _ in
            self?.lottieView.play(completion: { _ in
                UIApplication.shared.keyWindow?.replaceRootViewController(OnBoardingViewController(), animated: true, completion: nil)
            })
        })
    }
}
