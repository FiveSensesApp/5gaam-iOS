//
//  BaseBottomSheetController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/23.
//

import UIKit

import RxSwift
import RxCocoa

class BaseBottomSheetController: UIViewController {
    var containerView = UIView()
    var titleLabel = UILabel()
    var contentView = UIView()
    var cancelButton = BaseButton()
    
    var contentHeight: CGFloat = 0.0
    var isBackgroundDismissOn = true
    var isUp = false
    
    var disposeBag = DisposeBag()
    
    var dismissView = UIView()
    
    convenience init(title: String?, content: UIView, contentHeight: CGFloat) {
        self.init()
        
        self.titleLabel.text = title
        self.contentView = content
        self.contentHeight = contentHeight
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(hex: "000000").withAlphaComponent(0.7)
        self.view.addSubview(containerView)
        self.containerView.then {
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        self.containerView.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(20.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.containerView.addSubview(cancelButton)
        self.cancelButton.then {
            $0.setImage(UIImage(named: "닫기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.top.right.equalToSuperview().inset(20.0)
        }
        
        self.containerView.addSubview(contentView)
        self.contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(21.0)
            $0.bottom.equalToSuperview().inset(60.0)
            $0.top.equalTo(self.cancelButton.snp.bottom).offset(7.0)
        }
        
        self.view.addSubview(dismissView)
        self.dismissView.then {
            $0.backgroundColor = .clear
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.top)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
        if !isUp {
            self.contentView.layoutIfNeeded()
            isUp = true
            
            self.contentView.snp.remakeConstraints {
                $0.left.right.equalToSuperview().inset(21.0)
                $0.bottom.equalToSuperview().inset(60.0)
                $0.top.equalTo(self.cancelButton.snp.bottom).offset(7.0)
                $0.height.equalTo(self.contentHeight)
            }
            
            self.containerView.snp.remakeConstraints {
                //                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismissActionSheet()
            }
            .disposed(by: self.disposeBag)
        
        self.dismissView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.dismissActionSheet()
            }
            .disposed(by: self.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != containerView && self.isBackgroundDismissOn {
            self.dismissActionSheet()
        }
    }
    
    func dismissActionSheet() {
        self.containerView.snp.remakeConstraints{ [unowned self] in
            $0.top.equalTo(self.view.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] (completion) in
            if let s = self {
                s.dismiss(animated: false)
            }
        }
    }
    
    class func showBottomSheet(viewController: UIViewController, title: String?, content: UIView, contentHeight: CGFloat) {
        let vc = BaseBottomSheetController(title: title, content: content, contentHeight: contentHeight)
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: false)
    }
}
