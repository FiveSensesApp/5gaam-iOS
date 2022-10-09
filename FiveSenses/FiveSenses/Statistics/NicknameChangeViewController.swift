//
//  NicknameChangeViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/09.
//

import UIKit

import RxSwift
import RxCocoa

class NicknameChangeViewController: BaseSettingViewController {
    var nicknameTextField = SignTextField(type: .nickname, placeHolder: "최대 8자까지 설정 가능합니다.")
    var finishButton = BaseButton()
    
    private var currentNickname: String = ""
    private var currentUser: CreatedUser?
    private var nicknameValidationLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.title = "닉네임 수정"
        
        self.contentView.addSubview(nicknameTextField)
        self.nicknameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50.0)
        }
        
        self.contentView.addSubview(nicknameValidationLabel)
        self.nicknameValidationLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .red02
            $0.isHidden = true
            $0.text = "닉네임은 2자 이상, 8자 이하, 한글, 영어, 숫자만 사용 가능합니다."
        }.snp.makeConstraints {
            $0.top.equalTo(self.nicknameTextField.snp.bottom).offset(10.0)
            $0.height.equalTo(18.0)
            $0.left.right.equalToSuperview()
        }
        
        self.navigationBarView.addSubview(finishButton)
        self.finishButton.then {
            $0.setTitle("완료", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .disabled)
            $0.setTitleColor(.white, for: .normal)
            $0.isEnabled = false
            $0.setBackgroundImage(UIImage.color(.gray03), for: .disabled)
            $0.setBackgroundImage(UIImage.color(.black), for: .normal)
            $0.makeCornerRadius(radius: 19.0)
        }.snp.makeConstraints {
            $0.height.equalTo(38.0)
            $0.width.equalTo(74.0)
            $0.top.equalToSuperview().inset(44.0)
            $0.right.equalToSuperview().inset(21.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarView.backButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        UserServices.getUserInfo()
            .compactMap { $0 }
            .bind { [weak self] in
                self?.currentNickname = $0.createdUser.nickname
                self?.currentUser = $0.createdUser
                self?.nicknameTextField.text = $0.createdUser.nickname
            }
            .disposed(by: disposeBag)
        
        self.nicknameTextField
            .isConfirmed
            .skip(2)
            .bind(to: self.nicknameValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.nicknameTextField
            .isConfirmed
            .skip(2)
            .bind { [weak self] isConfirmed in
                guard let self = self else { return }

                self.finishButton.isEnabled = isConfirmed && (self.nicknameTextField.text != self.currentNickname)
            }
            .disposed(by: disposeBag)
        
        self.finishButton
            .rx.tap
            .withLatestFrom(self.nicknameTextField.rx.text.orEmpty)
            .flatMap { [weak self] nickname -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                let updatingUser = UpdatingUser(userId: self.currentUser!.id, nickname: nickname, isAlarmOn: self.currentUser!.isAlarmOn)
                
                return UserServices.updateUser(updatingUser: updatingUser)
            }
            .bind { [weak self] in
                if $0 {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
