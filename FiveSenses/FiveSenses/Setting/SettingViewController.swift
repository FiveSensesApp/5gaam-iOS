//
//  SettingViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/20.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

class SettingViewController: BaseSettingViewController {
    var alertSwitch = UISwitch()
    var timePicker = ColoredDatePicker()
    
    var passwordResetButtonView = SettingButtonView()
    var termsButtonView = SettingButtonView()
    var openSourceLicenseButtonView = SettingButtonView()
    
    var logoutButton = BaseButton()
    var withdrawalButton = BaseButton()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.title = "설정"
        
        self.contentView = UIStackView()
        self.scrollView.addSubview(self.contentView)
        let contentView = self.contentView as! UIStackView
        contentView.then {
            
            $0.backgroundColor = .white
            $0.spacing = 24.0
            $0.axis = .vertical
        
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // MARK: - 알림 / 시간
        let alertAndTimeStackView = makeButtonStackView()
        contentView.addArrangedSubview(alertAndTimeStackView)
        
        let alertButtonView = SettingButtonView()
        alertAndTimeStackView.addArrangedSubview(alertButtonView)
        _ = alertButtonView.then {
            $0.title = "알림 설정"
            $0.rightImageView.isHidden = true
            $0.addSubview(alertSwitch)
        }
        self.alertSwitch.then {
            $0.onTintColor = .black
            $0.tintColor = .gray02
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(9.0)
            $0.centerY.equalToSuperview()
        }
        
        let lineView = UIView()
        alertAndTimeStackView.addArrangedSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray02
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
        }
        
        let timeButtonView = SettingButtonView()
        alertAndTimeStackView.addArrangedSubview(timeButtonView)
        _ = timeButtonView.then {
            $0.title = "시간설정"
            $0.titleColor = .gray04
            $0.rightImageView.isHidden = true
            $0.addSubview(timePicker)
        }
        self.timePicker.then {
            $0.preferredDatePickerStyle = .compact
            $0.datePickerMode = .time
            $0.tintColor = .white
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(9.0)
            $0.centerY.equalToSuperview()
        }
        
        // MARK: - 비밀번호 재설정
        let passwordStackView = makeButtonStackView()
        contentView.addArrangedSubview(passwordStackView)
        
        passwordStackView.addArrangedSubview(passwordResetButtonView)
        _ = passwordResetButtonView.then {
            $0.title = "비밀번호 재설정"
        }
        
        // MARK: - 공지사항, 이용약관, 오픈소스, 버전
        let thirdSectionStackView = makeButtonStackView()
        contentView.addArrangedSubview(thirdSectionStackView)
        
        let noticeButtonView = SettingButtonView().then {
            $0.title = "공지사항 및 도움말"
            $0.rightImageView.image = UIImage(named: "외부로가기")
        }
        thirdSectionStackView.addArrangedSubview(noticeButtonView)
        
        
        _ = termsButtonView.then {
            $0.title = "이용약관"
        }
        thirdSectionStackView.addArrangedSubview(termsButtonView)
        
        _ = openSourceLicenseButtonView.then {
            $0.title = "오픈소스 라이선스"
        }
        thirdSectionStackView.addArrangedSubview(openSourceLicenseButtonView)
        
        let versionView = SettingButtonView().then {
            $0.title = "ver \((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")"
        }
        thirdSectionStackView.addArrangedSubview(versionView)
        
        // MARK: - 리뷰, SNS, 문의
        let lastSectionStackView = makeButtonStackView()
        contentView.addArrangedSubview(lastSectionStackView)
        
        let reviewButton = SettingButtonView().then {
            $0.title = "앱 리뷰 남기기"
            $0.rightImageView.image = UIImage(named: "외부로가기")
        }
        lastSectionStackView.addArrangedSubview(reviewButton)
        
        let goToSNS = SettingButtonView().then {
            $0.title = "공식 SNS이동"
            $0.rightImageView.image = UIImage(named: "외부로가기")
        }
        lastSectionStackView.addArrangedSubview(goToSNS)
        
        let questionButtonView = SettingButtonView().then {
            $0.title = "1:1 문의 / 요청"
            $0.rightImageView.image = UIImage(named: "외부로가기")
        }
        lastSectionStackView.addArrangedSubview(questionButtonView)
        
        // MARK: - 로그아웃, 계정탈퇴
        
        contentView.setCustomSpacing(15.0, after: lastSectionStackView)
        contentView.addArrangedSubview(logoutButton)
        self.logoutButton.then {
            $0.setTitle("로그아웃", for: .normal)
            $0.titleLabel?.font = .medium(16.0)
            $0.setTitleColor(.black, for: .normal)
        }.snp.makeConstraints {
            $0.height.equalTo(49.0)
        }
        
        contentView.setCustomSpacing(8.0, after: logoutButton)
        contentView.addArrangedSubview(withdrawalButton)
        self.withdrawalButton.then {
            $0.setTitle("계정 탈퇴", for: .normal)
            $0.titleLabel?.font = .medium(16.0)
            $0.setTitleColor(.gray02, for: .normal)
        }.snp.makeConstraints {
            $0.height.equalTo(49.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordResetButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(PasswordResetViewController(), animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.termsButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(TermsViewController(), animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.openSourceLicenseButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(OpenSourceViewController(), animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.logoutButton.rx.tap
            .bind { [weak self] in
                if let self = self {
                    TwoButtonAlertController.showAlert(viewController: self, title: "로그아웃", content: "정말 로그아웃 하시겠습니까?", buttonTitle: "예", cancelButtonTitle: "아니요")
                }
            }
            .disposed(by: disposeBag)
        
        self.withdrawalButton.rx.tap
            .bind { [weak self] in
                if let self = self {
                    TwoButtonAlertController.showAlert(viewController: self, title: "정말 탈퇴하실 건가요?", content: "그동안의 기록들이 모두 사라져요.", buttonTitle: "예", cancelButtonTitle: "아니요")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func makeButtonStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 12.0)
            $0.axis = .vertical
            $0.spacing = 9.0
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 9.0, left: 9.0, bottom: 9.0, right: 8.0)
        }
        
        return stackView
    }
}

class SettingButtonView: UIView {
    var titleLabel = UILabel()
    var title: String = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    var titleColor: UIColor = .black {
        didSet {
            self.titleLabel.textColor = self.titleColor
        }
    }
    var rightImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel.font = .bold(18.0)
        self.backgroundColor = .gray01
        
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(17.0)
            $0.top.bottom.equalToSuperview().inset(13.0)
        }
        
        self.addSubview(rightImageView)
        self.rightImageView.then {
            $0.image = UIImage(named: "우측화살표")
        }.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.right.equalToSuperview().inset(9.0)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(50.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColoredDatePicker: UIDatePicker {
    var changed = false
    override func addSubview(_ view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor.white, forKey: "textColor")
        }
        super.addSubview(view)
    }
}
