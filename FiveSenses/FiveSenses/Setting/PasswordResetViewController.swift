//
//  PasswordResetViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/21.
//

import UIKit

import RxSwift
import RxCocoa
import Toaster

class PasswordResetViewController: BaseSettingViewController {
    var originalPasswordInputView = PasswordInputView()
    var originalPasswordInfoLabel = UILabel()
    var newPasswordInputView = SignTextField(type: .password, placeHolder: "새로운 비밀번호를 입력해주세요.")
    var newPasswordReInputview = SignTextField(type: .password, placeHolder: "새로운 비밀번호를 다시 확인해주세요!")
    var newPasswordInfoLabel = UILabel()
    var finishButton = BaseButton()
    var passwordInfoLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        self.navigationBarView.title = "비밀번호 재설정"
        
        self.view.addSubview(originalPasswordInputView)
        self.originalPasswordInputView.then {
            $0.textField.attributedPlaceholder = NSAttributedString(string: "기존 비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray02])
            $0.textField.textColor = .white
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.view.addSubview(self.originalPasswordInfoLabel)
        self.originalPasswordInfoLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .red02
            $0.text = "기존 비밀번호를 확인해주세요."
            $0.textAlignment = .center
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.originalPasswordInputView.snp.bottom).offset(10.5)
        }
        
        self.view.addSubview(newPasswordInputView)
        self.newPasswordInputView.then {
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.top.equalTo(self.originalPasswordInfoLabel.snp.bottom).offset(7.5)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.view.addSubview(newPasswordReInputview)
        self.newPasswordReInputview.then {
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.top.equalTo(self.newPasswordInputView.snp.bottom).offset(10.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.view.addSubview(newPasswordInfoLabel)
        self.newPasswordInfoLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .gray04
            $0.text = "(영문, 숫자, 특수문자 중 2개 조합 10자 이상)"
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.newPasswordReInputview.snp.bottom).offset(10.0)
        }
        
        self.navigationBarView.addSubview(self.finishButton)
        self.finishButton.then {
            $0.setTitle("완료", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundImage(UIImage.color(.gray03), for: .disabled)
            $0.setBackgroundImage(UIImage.color(.black), for: .normal)
            $0.makeCornerRadius(radius: 19.0)
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(21.0)
            $0.width.equalTo(74.0)
            $0.height.equalTo(38.0)
            $0.centerY.equalTo(self.navigationBarView.backButton)
        }
        
        self.contentView.addSubview(passwordInfoLabel)
        self.passwordInfoLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .gray04
            $0.text = "(영문, 숫자, 특수문자 중 2개 조합 10자 이상)"
            $0.textAlignment = .center
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.newPasswordReInputview.snp.bottom).offset(10.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(19.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(
            self.newPasswordInputView
                .rx.text
                .orEmpty,
            self.newPasswordReInputview
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
            
            self.finishButton.isEnabled = $0
        }
        .disposed(by: disposeBag)
        
        self.finishButton.rx.tap
            .flatMap {
                return UserServices.changePassword(old: self.originalPasswordInputView.textField.text ?? "", new: self.newPasswordInputView.text ?? "")
            }
            .bind { [weak self] in
                guard let self = self else { return }
                if $0 == nil {
                    BaseAlertViewController.showAlert(viewController: self, title: "비밀번호 재설정 완료", content: "로그인 화면으로 이동합니다.", buttonTitle: "또 만나요!", dismissAction: {
                        KeyChainController.shared.delete(Constants.ServiceString, account: "Token")
                        UIApplication.shared.keyWindow?.replaceRootViewController(OnBoardingViewController(), animated: true, completion: nil)
                    })
                } else {
                    Toast(text: $0 ?? "").show()
                }
                
                
            }
            .disposed(by: self.disposeBag)
    }
}

class PasswordInputView: UIView {
    var textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray04
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(textField)
        self.textField.then {
            $0.font = .bold(16.0)
            $0.textColor = .gray01
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.textContentType = .oneTimeCode
            $0.isSecureTextEntry = true
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(22.0)
            $0.top.bottom.equalToSuperview().inset(15.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
