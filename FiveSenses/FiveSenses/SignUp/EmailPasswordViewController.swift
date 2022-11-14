//
//  EmailPasswordViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/05.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

class EmailPasswordViewController: SignUpBaseViewController {
    static var creatingUser = CreatingUser(nickname: "", isAlarmOn: false, email: "", password: "", alarmDate: "")
    
    var emailTextfield = SignTextField(type: .email, placeHolder: "이메일 주소를 입력해주세요.")
    var passwordTextfield = SignTextField(type: .password, placeHolder: "비밀번호를 입력해주세요.")
    var passwordRepeatTextfield = SignTextField(type: .password, placeHolder: "다시 한 번 비밀번호를 입력해주세요.")
    var passwordInfoLabel = UILabel()
    
    private var lineView = UIView()
    var ruleConfirmButton = BaseButton()
    private var ruleTitleLabel = UILabel()
    private var ruleSubTitleLabel = UILabel()
    private var ruleDetailButton = BaseButton()
    
    private var isPasswordCorrect = PublishRelay<Bool>()
    
    var isRuleConfirmed = BehaviorRelay<Bool>(value: false)
    var ruleConfirmed = BehaviorRelay<Bool>(value: false)
    var privacyConfirmed = BehaviorRelay<Bool>(value: false)
    var marketingConfirmed = BehaviorRelay<Bool>(value: false)
    
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
        
        self.contentView.addSubview(passwordInfoLabel)
        self.passwordInfoLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .gray04
            $0.text = "(영문, 숫자, 특수문자 중 2개 조합 10자 이상)"
            $0.textAlignment = .center
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.passwordRepeatTextfield.snp.bottom).offset(10.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(19.0)
        }
        
        self.contentView.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray03
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.passwordRepeatTextfield.snp.bottom).offset(64.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(1.0)
        }
        
        self.contentView.addSubview(ruleConfirmButton)
        self.ruleConfirmButton.then {
            $0.setImage(UIImage(named: "체크"), for: .normal)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.width.height.equalTo(40.0)
            $0.top.equalTo(lineView.snp.bottom).offset(6.0)
            $0.left.equalTo(lineView)
        }
        
        self.contentView.addSubview(ruleTitleLabel)
        self.ruleTitleLabel.then {
            $0.text = "오감 가입 약관에 모두 동의합니다."
            $0.font = .semiBold(14.0)
            $0.textColor = .black
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.left.equalTo(self.ruleConfirmButton.snp.right)
            $0.top.equalTo(lineView.snp.bottom).offset(19.0)
        }
        
        self.contentView.addSubview(ruleDetailButton)
        self.ruleDetailButton.then {
            $0.setImage(UIImage(named: "이용약관 보러가기"), for: .normal)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(5.0)
            $0.width.height.equalTo(40.0)
            $0.right.equalToSuperview().inset(20.0)
        }
        
        self.contentView.addSubview(ruleSubTitleLabel)
        self.ruleSubTitleLabel.then {
            $0.text = "(필수)이용약관, (필수)개인정보처리방침, (선택)마케팅 수신 동의"
            $0.font = .regular(10.0)
            $0.textColor = .gray02
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.left.equalTo(self.ruleTitleLabel)
            $0.top.equalTo(self.ruleTitleLabel.snp.bottom).offset(4.0)
            $0.right.equalTo(self.ruleDetailButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarView.backButton
            .rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.emailTextfield.isConfirmed
            .bind(to: self.passwordTextfield.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        self.emailTextfield.isConfirmed
            .bind(to: self.passwordRepeatTextfield.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.passwordTextfield
                .rx.text
                .orEmpty,
            self.passwordRepeatTextfield
                .rx.text
                .orEmpty
        )
        .map {
            if $0 == "" || $1 == "" { return false }
            return ($0 == $1)
        }
        .bind(to: self.isPasswordCorrect)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.passwordTextfield
                .rx.text
                .orEmpty,
            self.passwordRepeatTextfield
                .rx.text
                .orEmpty
        )
        .map { one, two -> Bool in
            if one == "" || two == "" { return true }
            return (one == two)
        }
        .bind { [weak self] in
            guard let self = self else { return }
            
            if !$0 {
                self.passwordInfoLabel.text = "* 비밀번호가 일치하지 않습니다!"
                self.passwordInfoLabel.textColor = .red02
            } else {
                self.passwordInfoLabel.text = "(영문, 숫자, 특수문자 중 2개 조합 10자 이상)"
                self.passwordInfoLabel.textColor = .gray04
            }
        }
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.passwordTextfield
                .isConfirmed,
            self.passwordRepeatTextfield
                .isConfirmed,
            self.emailTextfield
                .isConfirmed
        )
        .map { $0 && $1 && $2 }
        .bind { [weak self] in
            if $0 {
                self?.passwordInfoLabel.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        self.ruleDetailButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let vc = TermsBottomSheetController(title: "약관 확인하기", content: UIView(), contentHeight: 559.0)
                vc.allView.isConfirmed.accept(self.isRuleConfirmed.value)
                vc.ruleView.isConfirmed.accept(self.ruleConfirmed.value)
                vc.privacyView.isConfirmed.accept(self.privacyConfirmed.value)
                vc.marketingView.isConfirmed.accept(self.marketingConfirmed.value)
                vc.viewController = self
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        self.ruleConfirmButton
            .rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.ruleConfirmed.accept(!self.isRuleConfirmed.value)
                self.privacyConfirmed.accept(!self.isRuleConfirmed.value)
                self.marketingConfirmed.accept(!self.isRuleConfirmed.value)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(self.ruleConfirmed, self.privacyConfirmed, self.marketingConfirmed)
            .map { $0 && $1 && $2 }
            .distinctUntilChanged()
            .bind(to: self.isRuleConfirmed)
            .disposed(by: disposeBag)
        
        self.isRuleConfirmed
            .bind { [weak self] in
                if $0 {
                    self?.ruleConfirmButton.setImage(UIImage(named: "체크완료"), for: .normal)
                } else {
                    self?.ruleConfirmButton.setImage(UIImage(named: "체크"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.emailTextfield.isConfirmed,
            self.isPasswordCorrect
        )
        .map { $0 && $1 }
        .bind { [weak self] in
            guard let self = self else { return }
            
            self.lineView.isHidden = !$0
            self.ruleConfirmButton.isHidden = !$0
            self.ruleTitleLabel.isHidden = !$0
            self.ruleDetailButton.isHidden = !$0
            self.ruleSubTitleLabel.isHidden = !$0
            
            if !$0 {
                self.isRuleConfirmed.accept(false)
            }
        }
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.emailTextfield.isConfirmed,
            self.isPasswordCorrect,
            self.ruleConfirmed,
            self.privacyConfirmed
        )
        .map { $0 && $1 && $2 && $3 }
        .distinctUntilChanged()
        .bind { [weak self] in
            self?.navigationBarView.nextButton.isEnabled = $0
        }
        .disposed(by: disposeBag)
        
        self.navigationBarView.nextButton
            .rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                EmailPasswordViewController.creatingUser.email = self.emailTextfield.text ?? ""
                EmailPasswordViewController.creatingUser.password = self.passwordTextfield.text ?? ""
                
                self.navigationController?.pushViewController(EmailConfirmViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        self.emailTextfield.isConfirmed
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.passwordTextfield.isHidden = !$0
                self.passwordInfoLabel.isHidden = !$0
                self.passwordRepeatTextfield.isHidden = !$0
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive { height in
                
            }
    }
}
