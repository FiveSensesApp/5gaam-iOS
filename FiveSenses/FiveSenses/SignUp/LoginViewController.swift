//
//  LoginViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/04.
//

import UIKit

import RxSwift
import RxKeyboard

class LoginViewController: UIViewController {
    private var upperImageView = UIImageView()
    private var greetingLabel = UILabel()
    
    var emailTextfield = CMTextField(isPlaceHolderBold: true, placeHolder: "이메일 주소를 입력해주세요.", font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 22.0))
    var passwordTextfield = SignTextField(type: .password, placeHolder: "비밀번호를 입력해주세요.")
    
    var loginButton = BaseButton()
    var forgetButton = UILabel()
    
    var backButton = BaseButton()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = UIView()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(backButton)
        self.backButton.then {
            $0.setImage(UIImage(named: "뒤로가기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview().inset(44.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.view.addSubview(upperImageView)
        self.upperImageView.then {
            $0.image = UIImage(named: "로그인 상단 그래픽")
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.top.equalToSuperview().offset(121.0)
            $0.width.equalTo(98.0)
            $0.height.equalTo(26.0)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(greetingLabel)
        self.greetingLabel.then {
            $0.text = "만나서 반가워요!"
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.top.equalTo(self.upperImageView.snp.bottom).offset(25.0)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(emailTextfield)
        self.emailTextfield.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.keyboardType = .emailAddress
        }.snp.makeConstraints {
            $0.top.equalTo(self.greetingLabel.snp.bottom).offset(61.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.view.addSubview(passwordTextfield)
        self.passwordTextfield.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.textContentType = .oneTimeCode
            $0.isSecureTextEntry = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.emailTextfield.snp.bottom).offset(13.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(50.0)
        }
        
        self.view.addSubview(loginButton)
        self.loginButton.then {
            $0.backgroundColor = .black
            $0.setTitle("로그인", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.makeCornerRadius(radius: 23.0)
            $0.setBackgroundImage(UIImage.color(.black), for: .normal)
            $0.setBackgroundImage(UIImage.color(.gray02), for: .disabled)
            $0.isEnabled = false
        }.snp.makeConstraints {
            $0.height.equalTo(46.0)
            $0.width.equalTo(189.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(98.0)
        }
        
        self.view.addSubview(forgetButton)
        self.forgetButton.then {
            let string = NSMutableAttributedString(string: "비밀번호", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray03, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.gray03])
            string.append(NSMutableAttributedString(string: "를 모르겠다면?", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray03]))
            $0.attributedText = string
        }.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(63.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RxKeyboard.instance
            .visibleHeight
            .drive { [weak self] height in
                guard let self = self else { return }
                
                if height == 0.0 {
                    self.loginButton.snp.remakeConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(98.0)
                        $0.centerX.equalToSuperview()
                        $0.height.equalTo(46.0)
                        $0.width.equalTo(189.0)
                    }
                } else {
                    self.loginButton.snp.remakeConstraints {
                        $0.bottom.equalToSuperview().inset(height + 20.0)
                        $0.centerX.equalToSuperview()
                        $0.height.equalTo(46.0)
                        $0.width.equalTo(189.0)
                    }
                }
                
                UIView.animate(withDuration: 0, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest (
            self.emailTextfield.rx.text.orEmpty.map { $0 != "" },
            self.passwordTextfield.rx.text.orEmpty.map { $0 != "" }
        )
        .map { $0 && $1 }
        .bind(to: self.loginButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        self.loginButton
            .rx.tap
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                self.loginButton.isEnabled = false
                
                return AuthServices.login(
                    email: self.emailTextfield.text ?? "",
                    password: self.passwordTextfield.text ?? ""
                ).map {
                    $0?.meta.code == 200
                }
            }
            .flatMap {
                if $0 {
                    return UserServices.getUserInfo()
                } else {
                    return Observable.just(nil)
                }
            }
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.loginButton.isEnabled = true
                
                if $0 != nil {
                    Constants.CurrentUser = $0?.createdUser
                    UIApplication.shared.keyWindow?.replaceRootViewController(MainViewController.makeMainViewController(), animated: true, completion: nil)
                } else {
                    BaseAlertViewController.showAlert(viewController: self, title: "로그인 실패", content: "이메일 / 비밀번호를 확인해주세요.", buttonTitle: "확인")
                }
            }
            .disposed(by: disposeBag)
        
        self.backButton
            .rx.tap
            .bind { [weak self] in
                self?.navigationController?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.forgetButton
            .rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(FindPasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
