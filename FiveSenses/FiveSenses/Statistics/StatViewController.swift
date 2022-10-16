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
    var postDistributionView = PostDistributionView()
    
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
        
        self.contentView.addSubview(postDistributionView)
        self.postDistributionView.snp.makeConstraints {
            $0.top.equalTo(self.bannerPagerView.snp.bottom).offset(20.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(205.0)
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
        
        self.viewModel.output!.postDistribution
            .bind { [weak self] in
                let vals = $0.sorted(by: { $0.count > $1.count })
                self?.postDistributionView.distributionGraphView.setGraph(values: vals)
                self?.postDistributionView.setPostCount(values: vals)
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
