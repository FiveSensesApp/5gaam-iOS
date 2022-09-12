//
//  SignTextField.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/06.
//

import UIKit

import RxSwift
import RxCocoa

enum SignTextFieldType {
    case email
    case password
}

class SignTextField: CMTextField {
    var passwordRevealButton = UIButton()
    private var disposeBag = DisposeBag()
    
    var isConfirmed = BehaviorRelay<Bool>(value: false)
    
    convenience init(type: SignTextFieldType, placeHolder: String = "") {
        switch type {
        case .email:
            self.init(isPlaceHolderBold: true, placeHolder: placeHolder, font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 22.0))
        case .password:
            self.init(isPlaceHolderBold: true, placeHolder: placeHolder, font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 50.0))
        }
        
        _ = self.then {
            $0.textColor = .gray04
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
        }
                
        switch type {
        case .email:
            self.keyboardType = .emailAddress
        case .password:
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
            self.addSubview(passwordRevealButton)
            self.passwordRevealButton.then {
                $0.setImage(UIImage(named: "비밀번호 보기")?.withRenderingMode(.alwaysTemplate), for: .normal)
                $0.tintColor = .gray04
                $0.isHidden = true
            }.snp.makeConstraints {
                $0.width.height.equalTo(30.0)
                $0.right.equalToSuperview().inset(10.0)
                $0.centerY.equalToSuperview()
            }
        }
        
        self.rx.text
            .map { $0.isNilOrEmpty }
            .bind(to: self.passwordRevealButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.rx.text
            .orEmpty
            .bind { [weak self] in
                guard let self = self else { return }
                
                switch type {
                case .email:
                    self.isConfirmed.accept($0.range(of: type.textRule, options: .regularExpression) != nil)
                case .password:
                    var check = 0
                    
                    guard $0.count >= 10 else { return }
                    
                    // 숫자
                    if $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                        check += 1
                    }
                    
                    // 영어
                    if $0.rangeOfCharacter(from: CharacterSet.letters) != nil {
                        check += 1
                    }
                    
                    // 특수문자
                    if $0.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$&*")) != nil {
                        check += 1
                    }
                    
                    self.isConfirmed.accept(check >= 2)
                }
                
                
            }
            .disposed(by: disposeBag)
        
        self.passwordRevealButton
            .rx.tap
            .bind { [weak self] in
                self?.isSecureTextEntry.toggle()
            }
            .disposed(by: disposeBag)
    }
}
