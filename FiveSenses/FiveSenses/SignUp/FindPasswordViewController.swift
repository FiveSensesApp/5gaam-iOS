//
//  FindPasswordViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/08.
//

import UIKit

import MessageUI
import RxSwift
import RxKeyboard

class FindPasswordViewController: UIViewController, MFMailComposeViewControllerDelegate {
    private var upperImageView = UIImageView()
    private var greetingLabel = UILabel()
    
    var emailTextfield = CMTextField(isPlaceHolderBold: true, placeHolder: "가입했던 이메일 주소를 입력해주세요.", font: .bold(16.0), inset: UIEdgeInsets(top: 15.0, left: 22.0, bottom: 15.0, right: 22.0))
    
    var sendButton = BaseButton()
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
            $0.text = "가입하신 이메일로\n임시 비밀번호를 보낼게요!"
            $0.numberOfLines = 2
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
        
        self.view.addSubview(sendButton)
        self.sendButton.then {
            $0.backgroundColor = .black
            $0.setTitle("메일 전송", for: .normal)
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
            let string = NSMutableAttributedString(string: "이메일", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray03, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.gray03])
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
                    self.sendButton.snp.remakeConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(98.0)
                        $0.centerX.equalToSuperview()
                        $0.height.equalTo(46.0)
                        $0.width.equalTo(189.0)
                    }
                } else {
                    self.sendButton.snp.remakeConstraints {
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
        
        self.sendButton
            .rx.tap
            .withLatestFrom(self.emailTextfield.rx.text.orEmpty)
            .do { [weak self] _ in
                self?.sendButton.isUserInteractionEnabled = false
            }
            .flatMap {
                UserServices.lostPassword(email: $0)
            }
            .bind { [weak self] in
                guard let self = self else { return }
                
                if $0 {
                    BaseAlertViewController.showAlert(viewController: self, title: "임시 비밀번호 발급 완료", content: "비밀번호 재설정 후 사용해주세요!", buttonTitle: "확인", dismissAction: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                self.sendButton.isUserInteractionEnabled = true
            }
            .disposed(by: self.disposeBag)
        
        self.emailTextfield.rx.text
            .orEmpty
            .map {
                let pred = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return pred.evaluate(with: $0)
            }
            .bind(to: self.sendButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.backButton
            .rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.forgetButton
            .rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                EmailFindAlert.showAlert(viewController: self, title: "이메일 찾기", content: "공식 이메일로 문의주세요!", buttonTitle: "문의 메일", cancelButtonTitle: "뒤로 가기", okAction: {
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients(["hi.mangpo@gmail.com"])
                        
                        self.present(mail, animated: true)
                    } else {
                        
                    }
                }, cancelAction: {
                    
                })
            }
            .disposed(by: disposeBag)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class EmailFindAlert: TwoButtonAlertController {
    var backgroundView = UIView()
    var imageView = UIImageView()
    
    
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(hex: "000000").withAlphaComponent(0.7)
        
        self.okButton.addSubview(imageView)
        self.imageView.then {
            $0.image = UIImage(named: "MailSend")
        }.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.right.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
        
        self.okButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 11.0)
        
        self.contentView.snp.remakeConstraints {
            $0.left.right.equalToSuperview().inset(32.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    class func showAlert(
        viewController: UIViewController,
        title: String,
        content: String,
        buttonTitle: String,
        cancelButtonTitle: String,
        okAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) {
        let vc = EmailFindAlert(title: title, content: content, okButtonTitle: buttonTitle, cancelButtonTitle: cancelButtonTitle)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.okButton.rx.tap
            .bind {
                okAction()
            }
            .disposed(by: vc.disposeBag)
        vc.cancelButton.rx.tap
            .bind {
                vc.dismiss(animated: true)
            }
            .disposed(by: vc.disposeBag)
        viewController.present(vc, animated: true)
    }
}
