//
//  BaseSettingViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/21.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

class BaseSettingViewController: UIViewController {
    var navigationBarView = SettingNavigationView()
    
    var disposeBag = DisposeBag()
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    override func loadView() {
        super.loadView()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = .white
        self.view.addSubview(navigationBarView)
        self.navigationBarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(SettingNavigationView.height)
        }
        
        self.view.addSubview(scrollView)
        self.scrollView.then {
            $0.showsVerticalScrollIndicator = false
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(20.0)
        }
        
        self.scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarView.backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
