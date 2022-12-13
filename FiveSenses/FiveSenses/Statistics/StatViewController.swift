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
    var monthlySenseView = MonthlySenseView()
    var postCountGraphView = PostCountGraphView()
    
    var viewModel = StatViewModel(input: StatViewModel.Input())
    
    private var disposeBag = DisposeBag()
    
    private var isCellSelected = false
    private var primeIndex = -1
    
    var currentMonth = Date() {
        didSet {
            self.monthlySenseView.currentMonths = self.makeMonthlySense(monthlydata: self.viewModel.output!.monthlySenses.value)
            
            if currentMonth.isInSameMonth(as: self.viewModel.output!.monthlySenses.value[0].month) {
                self.monthlySenseView.leftButton.isEnabled = false
                self.monthlySenseView.leftButton.imageView?.tintColor = .gray02
            } else {
                self.monthlySenseView.leftButton.isEnabled = true
                self.monthlySenseView.leftButton.imageView?.tintColor = .gray04
            }
            
            if currentMonth.isInSameMonth(as: self.viewModel.output!.monthlySenses.value.last!.month) {
                self.monthlySenseView.rightButton.isEnabled = false
                self.monthlySenseView.rightButton.imageView?.tintColor = .gray02
            } else {
                self.monthlySenseView.rightButton.isEnabled = true
                self.monthlySenseView.rightButton.imageView?.tintColor = .gray04
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.contentView.removeFromSuperview()
        self.contentView.backgroundColor = .gray01
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.then {
            $0.delaysContentTouches = false
            $0.backgroundColor = .white
            $0.bounces = false
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
        self.userInfoView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
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
        
        self.contentView.addSubview(monthlySenseView)
        self.monthlySenseView.snp.makeConstraints {
            $0.top.equalTo(self.postDistributionView.snp.bottom).offset(20.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(400.0)
        }
        
        self.contentView.addSubview(postCountGraphView)
        self.postCountGraphView.snp.makeConstraints {
            $0.top.equalTo(self.monthlySenseView.snp.bottom).offset(20.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(380.0)
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postCountGraphView.graphColletionView.delegate = self
        self.postCountGraphView.graphColletionView.dataSource = self
        
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
        
        self.viewModel.output!.thisMonthSense
            .compactMap { $0 }
            .bind { [weak self] in
                self?.monthlySenseView.sense = $0.category
                self?.monthlySenseView.thisMonthSenseCountLabel.text = "신규 기록 \($0.cnt)개!"
                if $0.category == .none {
                    self?.monthlySenseView.thisMonthSenseCountLabel.text = "아직 이번 달에 작성한 기록이 없어요"
                }
            }
            .disposed(by: self.disposeBag)
        
        
        self.viewModel.output!.monthlySenses
            .bind  { [weak self] in
                self?.monthlySenseView.currentMonths = self?.makeMonthlySense(monthlydata: $0) ?? []
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output!.totalCount
            .bind { [weak self] in
                self?.postDistributionView.emptyImageView.isHidden = ($0 >= 10)
                self?.monthlySenseView.emptyImageView.isHidden = ($0 >= 10)
                self?.postCountGraphView.emptyImageView.isHidden = ($0 >= 10)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output!.countByDay
            .skip(1)
            .take(1)
            .bind { [weak self] _ in
                self?.postCountGraphView.graphColletionView.reloadData()
                self?.primeIndex = -1
            }
            .disposed(by: self.disposeBag)
        
        self.postCountGraphView.dailyMonthlySwitch.selectedType
            .bind { [weak self] _ in
                self?.isCellSelected = false
                self?.postCountGraphView.graphColletionView.reloadData()
                self?.primeIndex = -1
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
        
        self.userInfoView.badgeBackgroundImageView
            .rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                let vc = BadgeViewController()
                vc.modalPresentationStyle = .fullScreen
                
                self?.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.userInfoView.moreBadgeButton
            .rx.tap
            .bind { [weak self] _ in
                let vc = BadgeViewController()
                vc.modalPresentationStyle = .fullScreen
                
                self?.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.monthlySenseView.leftButton
            .rx.tap
            .bind { [weak self] in
                self?.currentMonth = self?.currentMonth.addComponent(value: -1, component: .month) ?? Date()
            }
            .disposed(by: disposeBag)
        
        self.monthlySenseView.rightButton
            .rx.tap
            .bind { [weak self] in
                self?.currentMonth = self?.currentMonth.addComponent(value: 1, component: .month) ?? Date()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func makeMonthlySense(monthlydata: [MonthlyCategory]) -> [MonthlyCategory?] {
        var array: [MonthlyCategory?] = [nil, nil, nil]
        
        monthlydata.enumerated().forEach { (index, value) in
            if value.month.isInSameMonth(as: currentMonth) {
                array[1] = value
                
                if index - 1 >= 0 {
                    array[0] = monthlydata[index - 1]
                }
                
                if index + 1 < monthlydata.count {
                    array[2] = monthlydata[index + 1]
                }
                
                return
            }
        }
        
        return array
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
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if index == 0 {
            if let url = URL(string: "https://www.notion.so/5gaam/5gaam-3b45d6083ad044ab869f0df6378933de") {
                UIApplication.shared.open(url)
            }
        } else if index == 2 {
            if let url = URL(string: "https://www.instagram.com/5gaam_app") {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension StatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    self.viewModel.output!.countByDay
//        .skip(1)
//        .take(1)
//        .bind { [weak self] _ in
//            guard let self = self else { return }
//
//            self.postCountGraphView.dailyMonthlySwitch.selectedType
//                .bind { [weak self] in
//                    guard let self = self else { return }
//
//                    for view in self.postCountGraphView.graphStackView.arrangedSubviews {
//                        view.removeFromSuperview()
//                    }
//
//                    switch $0 {
//                    case .daily:
//                        let max = Double(self.viewModel.output!.countByDay.value.map { $0.count }.max()!)
//                        self.postCountGraphView.graphStackView.spacing = 2.0
//                        for count in self.viewModel.output!.countByDay.value {
//                            let graph = PostCountGraph()
//                            graph.titleLabel.text = count.day.toString(format: .DailyGraph)
//                            graph.graphImageView.snp.updateConstraints {
//                                $0.height.equalTo(165.0 * (Double(count.count) / max))
//                            }
//                            self.postCountGraphView.graphStackView.addArrangedSubview(graph)
//                        }
//                    case .monthly:
//                        let max = Double(self.viewModel.output!.countByMonth.value.map { $0.count }.max()!)
//                        self.postCountGraphView.graphStackView.spacing = 9.0
//                        for count in self.viewModel.output!.countByMonth.value {
//                            let graph = PostCountGraph()
//                            graph.titleLabel.text = count.month.toString(format: .OnlyMonth)
//                            graph.graphImageView.snp.updateConstraints {
//                                $0.height.equalTo(165.0 * (Double(count.count) / max))
//                            }
//                            self.postCountGraphView.graphStackView.addArrangedSubview(graph)
//                        }
//                    }
//
//                }
//                .disposed(by: self.disposeBag)
//        }
//        .disposed(by: self.disposeBag)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = self.postCountGraphView.dailyMonthlySwitch.selectedType.value
        if type == .daily {
            return self.viewModel.output!.countByDay.value.count
        } else {
            return self.viewModel.output!.countByMonth.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCountGraph.identifier, for: indexPath) as! PostCountGraph
        
        let type = self.postCountGraphView.dailyMonthlySwitch.selectedType.value
        
        switch type {
        case .daily:
            let max = Double(self.viewModel.output!.countByDay.value.map { $0.count }.max()!)
            let count = self.viewModel.output!.countByDay.value[indexPath.item]
            cell.isPrime = false
            cell.titleLabel.text = count.day.toString(format: .DailyGraph)
            cell.countLabel.text = "\(count.count)개"
            cell.graphImageView.snp.updateConstraints {
                if max == 0 {
                    $0.height.equalTo(0.0)
                } else {
                    $0.height.equalTo(165.0 * (Double(count.count) / max))
                }
            }
            
            if !self.isCellSelected && count.day.isInSameDay(as: Date()) {
                cell.isPrime = true
                self.isCellSelected = true
            } else if primeIndex == indexPath.item {
                cell.isPrime = true
            } else {
                cell.isPrime = false
            }
            return cell
            
        case .monthly:
            let max = Double(self.viewModel.output!.countByMonth.value.map { $0.count }.max()!)
            let count = self.viewModel.output!.countByMonth.value[indexPath.item]
            cell.isPrime = false
            cell.titleLabel.text = count.month.toString(format: .OnlyMonth)
            cell.countLabel.text = "\(count.count)개"
            cell.graphImageView.snp.updateConstraints {
                if max == 0 {
                    $0.height.equalTo(0.0)
                } else {
                    $0.height.equalTo(165.0 * (Double(count.count) / max))
                }
                
            }
            
            if !self.isCellSelected && count.month.isInSameMonth(as: Date()) {
                cell.isPrime = true
                self.isCellSelected = true
            } else if self.isCellSelected && primeIndex == indexPath.item {
                cell.isPrime = true
            } else {
                cell.isPrime = false
            }
            return cell
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCountGraph.identifier, for: indexPath) as! PostCountGraph
        
//        for cellin in collectionView.visibleCells {
//            if let cellin = cellin as? PostCountGraph {
//                cellin.isPrime = false
//            }
//        }
        self.isCellSelected = true
        self.primeIndex = indexPath.item
        collectionView.reloadData()
    }
    
}
