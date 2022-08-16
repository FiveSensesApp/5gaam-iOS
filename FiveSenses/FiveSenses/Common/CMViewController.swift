//
//  CMViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/20.
//

import UIKit

class CMViewController: UIViewController {
    
    var navigationBarView = CMNavigationBarView()
    var contentView = UIView()
    
    override func loadView() {
        self.view = UIView()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.addSubview(self.navigationBarView)
        self.navigationBarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(136.0)
        }
        
        self.view.insertSubview(self.contentView, belowSubview: self.navigationBarView)
        self.contentView.then {
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
