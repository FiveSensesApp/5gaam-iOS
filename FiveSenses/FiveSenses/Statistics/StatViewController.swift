//
//  StatViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/09.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher
import FSPagerView

final class StatViewController: CMViewController {
    var userInfoView = StatUserInfoView()
    var bannerPagerView = FSPagerView()
    
    var viewModel = StatViewModel(input: StatViewModel.Input())
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        self.contentView.removeFromSuperview()
        self.contentView.backgroundColor = .gray01
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.then {
            $0.delaysContentTouches = false
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        self.contentView.addSubview(userInfoView)
        userInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(397.0)
        }
        
        self.contentView.addSubview(bannerPagerView)
        self.bannerPagerView.then {
            $0.register(BannerPagerCell.self, forCellWithReuseIdentifier: BannerPagerCell.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.automaticSlidingInterval = 2.5
            $0.isInfinite = true
            $0.backgroundColor = .clear
        }.snp.makeConstraints {
            $0.top.equalTo(self.userInfoView.snp.bottom).offset(20.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(self.bannerPagerView.snp.width).multipliedBy(100.0 / 335.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.output!.userInfo
            .compactMap { $0 }
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.userInfoView.nicknameLabel.text = $0.createdUser.nickname
                self.userInfoView.emailLabel.text = $0.createdUser.email
                self.userInfoView.recordDue = ((Date() - $0.createdUser.createdDate).day ?? 0) + 1
                self.userInfoView.numberOfPost = Constants.TotalCountOfPost
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output!.previewBadgesUrl
            .filter { $0.count > 0 }
            .bind { [weak self] in
                guard let self = self else { return }
                
                for view in self.userInfoView.badgeStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                
                for url in $0 {
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: URL(string: url), options: [.processor(SVGProcessor())])
                    self.userInfoView.badgeStackView.addArrangedSubview(imageView)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output!.representBadgeUrl
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.userInfoView.representBadgeImageView.kf.setImage(with: URL(string: $0 ?? ""), placeholder: UIImage(named: "대표뱃지) 없을 때"), options: [.processor(SVGProcessor())])
            }
            .disposed(by: self.disposeBag)
        
        // MARK: - Button Actions
        self.userInfoView.nicknameChangeButton
            .rx.tap
            .bind { [weak self] in
                let vc = NicknameChangeViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.userInfoView.settingButton
            .rx.tap
            .bind { [weak self] in
                let vc = SettingViewController()
                vc.modalPresentationStyle = .fullScreen
                
                self?.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.userInfoView.moreBadgeButton
            .rx.tap
            .bind { [weak self] in
                let vc = BadgeViewController()
                vc.modalPresentationStyle = .fullScreen
                
                self?.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.userInfoView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30.0)
    }
}

extension StatViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: BannerPagerCell.identifier, at: index) as! BannerPagerCell
        
        cell.bannerImageView.image = UIImage(named: "Banner\(index + 1)")
        
        return cell
    }
}

class StatUserInfoView: UIView {
    var settingButton = BaseButton()
    var nicknameLabel = UILabel()
    var nicknameChangeButton = BaseButton()
    var emailLabel = UILabel()
    var representBadgeImageView = UIImageView()
    
    private var recordDueImageView = UIImageView()
    private var recordDueLabel = UILabel()
    private var numberOfPostImageView = UIImageView()
    private var numberOfPostLabel = UILabel()
    
    private var badgeBackgroundImageView = UIImageView()
    private var badgeTitleLabel = UILabel()
    var moreBadgeButton = BaseButton()
    var badgeStackView = UIStackView()
    
    var recordDue: Int = 0 {
        didSet {
            self.recordDueLabel.text = "기록한지   D+\(recordDue)"
        }
    }
    
    var numberOfPost: Int = 0 {
        didSet {
            self.numberOfPostLabel.text = "기록갯수   \(numberOfPost)개"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(settingButton)
        self.settingButton.then {
            $0.setImage(UIImage(named: "설정 아이콘"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview().inset(44.0)
            $0.right.equalToSuperview().inset(21.0)
        }
        
        self.addSubview(nicknameLabel)
        self.nicknameLabel.then {
            $0.font = .bold(26.0)
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(98.0)
            $0.left.equalToSuperview().inset(20.0)
            $0.height.equalTo(31.0)
        }
        
        self.addSubview(nicknameChangeButton)
        self.nicknameChangeButton.then {
            $0.setImage(UIImage(named: "수정 아이콘 1"), for: .normal)
        }.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel)
            $0.left.equalTo(self.nicknameLabel.snp.right)
            $0.width.height.equalTo(31.0)
        }
        
        self.addSubview(emailLabel)
        self.emailLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray03
        }.snp.makeConstraints {
            $0.height.equalTo(18.0)
            $0.top.equalTo(self.nicknameLabel.snp.bottom)
            $0.left.equalTo(self.nicknameLabel)
        }
        
        self.addSubview(representBadgeImageView)
        self.representBadgeImageView.then {
            $0.image = UIImage(named: "대표뱃지) 없을 때")
        }.snp.makeConstraints {
            $0.width.height.equalTo(120.0)
            $0.top.equalToSuperview().inset(93.0)
            $0.right.equalToSuperview().inset(20.0)
        }
        
        self.addSubview(recordDueImageView)
        self.recordDueImageView.then {
            $0.image = UIImage(named: "토글) 달력별 1")
        }.snp.makeConstraints {
            $0.top.equalTo(self.emailLabel.snp.bottom).offset(19.0)
            $0.width.height.equalTo(14.0)
            $0.left.equalTo(self.emailLabel)
        }
        
        self.addSubview(recordDueLabel)
        self.recordDueLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.height.equalTo(22.0)
            $0.centerY.equalTo(self.recordDueImageView)
            $0.left.equalTo(self.recordDueImageView.snp.right).offset(5.0)
        }
        
        self.addSubview(numberOfPostImageView)
        self.numberOfPostImageView.then {
            $0.image = UIImage(named: "기록갯수 아이콘")
        }.snp.makeConstraints {
            $0.top.equalTo(self.recordDueImageView.snp.bottom).offset(9.0)
            $0.width.height.equalTo(14.0)
            $0.left.equalTo(self.emailLabel)
        }
        
        self.addSubview(numberOfPostLabel)
        self.numberOfPostLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.height.equalTo(22.0)
            $0.centerY.equalTo(self.numberOfPostImageView)
            $0.left.equalTo(self.numberOfPostImageView.snp.right).offset(5.0)
        }
        
        self.addSubview(badgeBackgroundImageView)
        self.badgeBackgroundImageView.then {
            $0.image = UIImage(named: "획득한 뱃지 bg")
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(142.0)
            $0.top.equalTo(self.representBadgeImageView.snp.bottom).offset(22.0)
        }
        
        self.addSubview(badgeTitleLabel)
        self.badgeTitleLabel.then {
            $0.font = .bold(18.0)
            $0.textColor = .black
            $0.text = "획득한 뱃지"
        }.snp.makeConstraints {
            $0.centerX.equalTo(self.badgeBackgroundImageView)
            $0.top.equalTo(self.badgeBackgroundImageView).offset(20.0)
            $0.height.equalTo(22.0)
        }
        
        self.addSubview(moreBadgeButton)
        self.moreBadgeButton.then {
            $0.setImage(UIImage(named: "뱃지 상세 보러가기"), for: .normal)
        }.snp.makeConstraints {
            $0.top.equalTo(self.badgeBackgroundImageView).offset(8.0)
            $0.right.equalTo(self.badgeBackgroundImageView).inset(3.0)
            $0.width.height.equalTo(44.0)
        }
        
        self.addSubview(badgeStackView)
        self.badgeStackView.then {
            $0.axis = .horizontal
            $0.spacing = 11.0
            $0.distribution = .fillEqually
        }.snp.makeConstraints {
            $0.top.equalTo(self.badgeTitleLabel.snp.bottom).offset(18.0)
            $0.left.right.equalTo(self.badgeBackgroundImageView).inset(21.0)
            $0.bottom.equalTo(self.badgeBackgroundImageView).inset(17.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
