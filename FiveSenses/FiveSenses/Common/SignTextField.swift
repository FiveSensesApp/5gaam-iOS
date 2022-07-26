//
//  SignTextField.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/06.
//

import UIKit

import RxSwift
import RxCocoa
import Toaster

enum SignTextFieldType {
    case email
    case password
    case none
    case nickname
}

class SignTextField: CMTextField {
    var passwordRevealButton = UIButton()
    private var disposeBag = DisposeBag()
    
    var isConfirmed = BehaviorRelay<Bool>(value: false)
    
    convenience init(type: SignTextFieldType, placeHolder: String = "") {
        self.init()
        
        switch type {
        case .email, .nickname:
            self.init(isPlaceHolderBold: true, placeHolder: placeHolder, font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 22.0))
        case .password:
            self.init(isPlaceHolderBold: true, placeHolder: placeHolder, font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 50.0))
        default:
            self.init(isPlaceHolderBold: true, placeHolder: placeHolder, font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 22.0))
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
        default:
            break
        }
        
        self.rx.text
            .map { $0.isNilOrEmpty }
            .bind(to: self.passwordRevealButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        let pred = NSPredicate(format:"SELF MATCHES %@", type.textRule)
        
        switch type {
        case .email:
            self.rx.text
                .orEmpty
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .flatMap { text -> Observable<Bool> in
                    if pred.evaluate(with: text) {
                        return UserServices.validateDuplicate(email: text).map {
                            if $0?.meta.code != 200 {
                                Toast(text: $0?.meta.msg ?? "").show()
                            }
                            return $0?.meta.code == 200
                        }
                    } else {
                        return Observable.just(false)
                    }
                }
                .bind(to: self.isConfirmed)
                .disposed(by: disposeBag)
        case .password:
            self.rx.text
                .orEmpty
                .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
                .map {
                    var check = 0
                    
                    guard $0.count >= 10 else { return false }
                    
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
                    
                    return check >= 2
                }
                .bind(to: self.isConfirmed)
                .disposed(by: disposeBag)
        case .nickname:
            self.rx.text
                .orEmpty
                .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
                .map { text -> Bool in
                    return pred.evaluate(with: text)
                }
                .bind(to: self.isConfirmed)
                .disposed(by: disposeBag)
            
        default:
            break
        }
        
        self.passwordRevealButton
            .rx.tap
            .bind { [weak self] in
                self?.isSecureTextEntry.toggle()
                if self?.isSecureTextEntry == false {
                    self?.passwordRevealButton.tintColor = .red02
                    self?.textColor = .red02
                } else {
                    self?.passwordRevealButton.tintColor = .gray04
                    self?.textColor = .gray04
                }
            }
            .disposed(by: disposeBag)
    }
}
