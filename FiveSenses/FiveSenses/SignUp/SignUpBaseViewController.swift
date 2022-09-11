//
//  SignUpBaseViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/05.
//

import UIKit

import RxSwift
import RxCocoa

class SignUpBaseViewController: UIViewController {
    var navigationBarView = SignUpNavigationView()
    
    var disposeBag = DisposeBag()
    var contentView = UIView()
    
    private var progressImageView = UIImageView()
    var progress: Int = 1 {
        didSet {
            progressImageView.image = UIImage(named: "회원가입 \(progress)단계")
        }
    }
    
    var titleLabel = UILabel()
    override var title: String? {
        didSet {
            self.titleLabel.text = title ?? ""
        }
    }
    
    var subtitleLabel = UILabel()
    var subtitle: String = "" {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = .white
        self.view.addSubview(navigationBarView)
        self.navigationBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(SignUpNavigationView.height)
        }
        
        self.view.addSubview(contentView)
        self.contentView.then {
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(progressImageView)
        self.progressImageView.then {
            $0.image = UIImage(named: "회원가입 1단계")
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(98.0)
            $0.height.equalTo(26.0)
        }
        
        self.contentView.addSubview(titleLabel)
        self.titleLabel.then {
            $0.text = "계정을 생성합니다."
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.progressImageView.snp.bottom).offset(25.0)
            $0.height.equalTo(31.0)
        }
        
        self.contentView.addSubview(subtitleLabel)
        self.subtitleLabel.then {
            $0.text = "한 번 가입하면 기기를 변경해도 기록이 유지돼요!"
            $0.font = .regular(14.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4.0)
            $0.height.equalTo(21.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarView.backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class SignUpNavigationView: UIView {
    static let height = 38.0
    
    var backButton = UIButton()
    var nextButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(backButton)
        self.backButton.then {
            $0.setImage(UIImage(named: "뒤로가기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.left.equalToSuperview().inset(21.0)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(nextButton)
        self.nextButton.then {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.white, for: .disabled)
            $0.setBackgroundImage(UIImage.color(.gray03), for: .disabled)
            $0.setBackgroundImage(UIImage.color(.black), for: .normal)
            $0.makeCornerRadius(radius: 19.0)
            $0.isEnabled = false
        }.snp.makeConstraints {
            $0.width.equalTo(74.0)
            $0.height.equalTo(38.0)
            $0.right.equalToSuperview().inset(21.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
