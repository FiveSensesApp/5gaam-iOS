//
//  NicknameViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/13.
//

import UIKit

import RxSwift
import RxCocoa

class NicknameViewController: SignUpBaseViewController {
    var nicknameTextField = SignTextField(type: .nickname, placeHolder: "최대 8자까지 설정 가능합니다.")
    private var infoLabel = UILabel()
    private var failLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        
        self.progress = 3
        self.title = "어떻게 불러드릴까요?"
        self.subtitle = "닉네임은 언제든 수정 가능합니다. 편하게 입력해주세요!"
        
        self.contentView.addSubview(nicknameTextField)
        self.nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(35.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.contentView.addSubview(infoLabel)
        self.infoLabel.then {
            $0.font = .regular(12.0)
            $0.text = "2글자 이상 한글, 영어, 숫자만 가능합니다.\n특수문자 및 이모지는 사용 불가해요."
            $0.numberOfLines = 2
            $0.textColor = .gray04
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(self.nicknameTextField.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(failLabel)
        self.failLabel.then {
            $0.isHidden = true
            $0.font = .regular(12.0)
            $0.textColor = .red02
            $0.text = "* 허용되지 않는 문자가 포함되어있습니다!"
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.nicknameTextField.snp.bottom).offset(10.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nicknameTextField
            .isConfirmed
            .skip(2)
            .debug()
            .bind { [weak self] isConfirmed in
                guard let self = self else { return }
                
                self.infoLabel.isHidden = !isConfirmed
                self.failLabel.isHidden = isConfirmed
                self.navigationBarView.nextButton.isEnabled = isConfirmed
            }
            .disposed(by: disposeBag)
        
        self.navigationBarView.nextButton
            .rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                EmailPasswordViewController.creatingUser.nickname = self.nicknameTextField.text ?? ""
                
                self.navigationController?.pushViewController(PushAllowViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
