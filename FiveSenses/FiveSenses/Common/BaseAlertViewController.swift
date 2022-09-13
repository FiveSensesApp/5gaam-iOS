//
//  BaseAlertViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/23.
//

import UIKit

import RxSwift
import RxCocoa

class BaseAlertViewController: UIViewController {
    var contentView = UIView()
    var titleLabel = UILabel()
    var contentLabel = UILabel()
    var okButton = BaseButton()
    
    var isBackgroundDismissOn = true
    
    var disposeBag = DisposeBag()
    
    convenience init(title: String?, content: String?, buttonTitle: String?) {
        self.init()
        
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.okButton.setTitle(buttonTitle, for: .normal)
    }
    
    override func loadView() {
        self.view = UIView()
        
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        self.view.addSubview(contentView)
        self.contentView.then {
            $0.makeCornerRadius(radius: 12.0)
            $0.backgroundColor = .gray01
            $0.isMultipleTouchEnabled = true
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(100.0)
            $0.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(20.0)
            $0.textColor = .black
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10.0)
            $0.top.equalToSuperview().inset(25.0)
        }
        
        self.contentView.addSubview(contentLabel)
        self.contentLabel.then {
            $0.font = .medium(16.0)
            $0.textColor = .gray04
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10.0)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4.0)
        }
        
        self.contentView.addSubview(okButton)
        self.okButton.then {
            $0.makeCornerRadius(radius: 22.5)
            $0.backgroundColor = .gray04
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(20.5)
            $0.bottom.equalToSuperview().inset(22.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(124.0)
            $0.height.equalTo(44.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.okButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.contentView.snp.updateConstraints {
            $0.left.right.equalToSuperview().inset(32.5)
        }
        
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            
//            self?.view.layoutIfNeeded()
//        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != contentView && self.isBackgroundDismissOn {
            self.dismiss(animated: true)
        }
    }
    
    class func showAlert(viewController: UIViewController, title: String, content: String, buttonTitle: String) {
        let vc = BaseAlertViewController(title: title, content: content, buttonTitle: buttonTitle)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true)
    }
}


