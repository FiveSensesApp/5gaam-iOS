//
//  TwoButtonAlertController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/23.
//

import UIKit

import RxSwift
import RxCocoa

class TwoButtonAlertController: BaseAlertViewController {
    var cancelButton = BaseButton()
    
    convenience init(title: String?, content: String?, okButtonTitle: String?, cancelButtonTitle: String?) {
        self.init()
        
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.okButton.setTitle(okButtonTitle, for: .normal)
        self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
    }
    
    override func loadView() {
        super.loadView()
        
        self.okButton.snp.remakeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(20.5)
            $0.left.equalTo(self.contentView.snp.centerX).offset(7.5)
            $0.right.equalToSuperview().inset(24.0)
            $0.bottom.equalToSuperview().inset(22.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
        }
        
        self.contentView.addSubview(cancelButton)
        self.cancelButton.then {
            $0.makeCornerRadius(radius: 22.5)
            $0.backgroundColor = .gray03
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(20.5)
            $0.right.equalTo(self.contentView.snp.centerX).offset(-7.5)
            $0.left.equalToSuperview().inset(24.0)
            $0.bottom.equalToSuperview().inset(22.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44.0)
        }
    }
    
    class func showAlert(viewController: UIViewController, title: String, content: String, buttonTitle: String, cancelButtonTitle: String) {
        let vc = TwoButtonAlertController(title: title, content: content, okButtonTitle: buttonTitle, cancelButtonTitle: cancelButtonTitle)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true)
    }
}
