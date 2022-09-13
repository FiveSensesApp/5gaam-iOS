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
    private var codeFailLabel = UILabel()
    
    var viewModel: EmailConfirmViewModel!
    
    override func loadView() {
        super.loadView()
        
        self.progress = 2
        self.title = "이메일을 인증합니다."
        self.subtitle = "생성한 계정 이메일로 인증 코드를 보내드릴게요!"
        self.navigationBarView.nextButton.setTitle("완료", for: .normal)
        
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
        self.codeTextField.then {
            $0.isEnabled = false
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20.0)
            $0.left.equalTo(self.sendCodeButton.snp.right).offset(12.0)
            $0.height.equalTo(51.0)
            $0.top.equalTo(self.sendCodeButton)
        }
        
        self.contentView.addSubview(codeFailLabel)
        self.codeFailLabel.then {
            $0.font = .regular(12.0)
            $0.text = "* 인증코드를 다시 입력해주세요."
            $0.textColor = .red02
            $0.isHidden = true
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(self.codeTextField.snp.bottom).offset(10.0)
            $0.height.equalTo(18.0)
            $0.left.right.equalTo(self.codeTextField)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = EmailConfirmViewModel(
            input: EmailConfirmViewModel.Input(
                codeSendTapped: self.sendCodeButton.rx.tap,
                code: self.codeTextField.rx.text.orEmpty.asObservable(),
                finishTapped: self.navigationBarView.nextButton.rx.tap
            )
        )
        
        self.codeTextField.rx.text
            .orEmpty
            .map { $0 != "" }
            .bind(to: self.navigationBarView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        
        guard let output = self.viewModel.output else { return }
        
        self.sendCodeButton.rx.tap
            .bind { [weak self] in
                self?.sendCodeButton.isEnabled = false
                self?.sendCodeButton.setTitle("재전송", for: .normal)
                self?.sendCodeButton.backgroundColor = .gray03
            }
            .disposed(by: disposeBag)
        
        output.isCodeSendTapped
            .drive { [weak self] in
                guard let self = self, $0 else { return }
                
                self.sendCodeButton.isEnabled = true
                self.codeFailLabel.isHidden = true
                self.codeTextField.isEnabled = $0
            }
            .disposed(by: disposeBag)
        
        output.isConfirmed
            .drive { [weak self] in
                guard let self = self else { return }
                
                if !$0 {
                    self.codeFailLabel.isHidden = false
                } else {
                    self.codeFailLabel.isHidden = true
                    self.navigationController?.pushViewController(NicknameViewController(), animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
