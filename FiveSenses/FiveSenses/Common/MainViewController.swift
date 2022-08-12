//
//  MainViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/10.
//

import UIKit

class MainViewController: UITabBarController {
    var writeButton = BaseButton()
    
    override func loadView() {
        super.loadView()
        
        _ = self.writeButton.then {
            $0.setImage(UIImage(named: "기록 시작 버튼"), for: .normal)
        }
        
        self.tabBar.backgroundColor = .white
        
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
        
        self.view.insertSubview(self.writeButton, aboveSubview: self.tabBar)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var frame = self.tabBar.frame
        frame.size.height = 82.0
        frame.origin.y = self.view.frame.size.height - 82.0
        
        self.tabBar.frame = frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.writeButton.frame = CGRect(x: self.tabBar.center.x - 34.5, y: self.view.bounds.height - 97.0, width: 69.0, height: 69.0)
    }
}
