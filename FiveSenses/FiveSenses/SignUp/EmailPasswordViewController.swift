//
//  EmailPasswordViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/05.
//

import UIKit

class EmailPasswordViewController: SignUpBaseViewController {
    var emailTextfield = SignTextField(type: .email, placeHolder: "이메일 주소를 입력해주세요.")
    var passwordTextfield = SignTextField(type: .password, placeHolder: "비밀번호를 입력해주세요.")
    var passwordRepeatTextfield = SignTextField(type: .password, placeHolder: "다시 한 번 비밀번호를 입력해주세요.")
    
    override func loadView() {
        super.loadView()
        
        self.progress = 1
        self.title = "계정을 생성합니다."
        self.subtitle = "한 번 가입하면 기기를 변경해도 기록이 유지돼요!"
        
        self.contentView.addSubview(emailTextfield)
        self.emailTextfield.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.keyboardType = .emailAddress
        }.snp.makeConstraints {
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(36.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        let emailInfoLabel = UILabel()
        self.contentView.addSubview(emailInfoLabel)
        emailInfoLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .gray04
            $0.text = "실제 사용중인 계정을 입력해주세요!"
        }.snp.makeConstraints {
            $0.top.equalTo(self.emailTextfield.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18.0)
        }
        
        self.contentView.addSubview(passwordTextfield)
        self.passwordTextfield.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.textContentType = .oneTimeCode
            $0.isSecureTextEntry = true
        }.snp.makeConstraints {
            $0.top.equalTo(emailInfoLabel.snp.bottom).offset(10.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.contentView.addSubview(passwordRepeatTextfield)
        self.passwordRepeatTextfield.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.textContentType = .oneTimeCode
            $0.isSecureTextEntry = true
        }.snp.makeConstraints {
            $0.top.equalTo(passwordTextfield.snp.bottom).offset(10.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
    }
}
