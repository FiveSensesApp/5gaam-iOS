//
//  MainViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/10.
//

import UIKit

import RxSwift

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    var writeButton = BaseButton()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        _ = self.writeButton.then {
            $0.setImage(UIImage(named: "기록 시작 버튼"), for: .normal)
        }
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .gray02
        
        let appearance = UITabBarAppearance().then {
            $0.backgroundColor = .white
        }
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.view.insertSubview(self.writeButton, aboveSubview: self.tabBar)
        self.writeButton.rx.tap
            .bind { [weak self] in
                if let self = self, let vc = self.selectedViewController {
                    
                    WriteBottomSheetViewController.showBottomSheet(viewController: vc, type: .category, tabBar: self.tabBar, writeButton: self.writeButton)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var frame = self.tabBar.frame
        frame.size.height = 82.0
        frame.origin.y = self.view.frame.size.height - 82.0
        
        self.tabBar.frame = frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers?[1].tabBarItem.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.writeButton.frame = CGRect(x: self.tabBar.center.x - 34.5, y: self.view.bounds.height - self.tabBar.frame.height - 15.0, width: 69.0, height: 69.0)
    }
    
    static func makeMainViewController() -> MainViewController {
        let mainViewController = MainViewController()
        let vc1 = TastesStorageViewController().then {
            $0.view.backgroundColor = .white
            $0.tabBarItem.image = UIImage(named: "보관함 아이콘")
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
        }
        let vc2 = UIViewController().then {
            $0.tabBarItem.isEnabled = false
        }
        let vc3 = StatViewController().then {
            $0.tabBarItem.image = UIImage(named: "성향분석 아이콘")
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
        }
        mainViewController.viewControllers = [vc1, vc2, vc3]
        
        return mainViewController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        viewControllers[1].tabBarItem.isEnabled = false
    }
}
