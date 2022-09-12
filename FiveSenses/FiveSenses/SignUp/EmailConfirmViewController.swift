//
//  EmailConfirmViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import UIKit

class EmailConfirmViewController: SignUpBaseViewController {
    
    var emailTextfield = SignTextField(type: .none, placeHolder: "")
    
    private var infoLabel = UILabel()
    private var sendCodeButton = UIButton()
    var codeTextField = SignTextField(type: .none, placeHolder: "인증코드를 입력해주세요.")
    
    override func loadView() {
        super.loadView()
        
        self.progress = 2
        self.title = "이메일을 인증합니다."
        self.subtitle = "생성한 계정 이메일로 인증 코드를 보내드릴게요!"
        
        self.contentView.addSubview(emailTextfield)
        self.emailTextfield.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.keyboardType = .emailAddress
            $0.text = EmailPasswordViewController.creatingUser.email
            $0.isEnabled = false
        }.snp.makeConstraints {
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(36.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.contentView.addSubview(infoLabel)
        self.infoLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .gray04
            $0.text = "여기로 인증코드를 보낼게요!"
        }.snp.makeConstraints {
            $0.top.equalTo(self.emailTextfield.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18.0)
        }
        
        self.contentView.addSubview(sendCodeButton)
        self.sendCodeButton.then {
            $0.backgroundColor = .black
            $0.makeCornerRadius(radius: 12.0)
            $0.setTitle("코드전송", for: .normal)
            $0.titleLabel?.font = .bold(16.0)
            $0.setTitleColor(.white, for: .normal)
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.infoLabel.snp.bottom).offset(10.0)
            $0.height.equalTo(51.0)
            $0.width.equalTo(88.0)
        }
        
        self.contentView.addSubview(codeTextField)
        self.codeTextField.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20.0)
            $0.left.equalTo(self.sendCodeButton.snp.right).offset(12.0)
            $0.height.equalTo(51.0)
            $0.top.equalTo(self.sendCodeButton)
        }
    }
}
