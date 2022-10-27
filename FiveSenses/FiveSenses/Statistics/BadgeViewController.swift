//
//  BadgeViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/10.
//

import UIKit

import RxCocoa
import RxSwift
import Toaster

class BadgeViewController: CMViewController {
    var backButton = BaseButton()
    
    private var disposeBag = DisposeBag()
    
    var representBadgeImageView = UIImageView()
    var representBadgeTitleLabel = UILabel()
    var representBadgeDescriptionLabel = UILabel()
    
    var representBadgeTitle: String = "" {
        didSet {
            let string = NSMutableAttributedString(string: "대표 뱃지 | ", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray04])
            string.append(NSMutableAttributedString(string: representBadgeTitle, attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.black]))
            self.representBadgeTitleLabel.attributedText = string
        }
    }
    
    private var badgeCollectionTitleLabel = UILabel()
    var badgeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var badgeCountLabel = UILabel()
    
    var viewModel = BadgeViewModel()
    
    override func loadView() {
        super.loadView()
        
        self.representBadgeTitle = "비어있어요"
        
        self.navigationBarView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        let topView = UIView()
        self.contentView.addSubview(topView)
        topView.then {
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44.0)
            $0.left.right.equalToSuperview()
        }
        
        topView.addSubview(backButton)
        self.backButton.then {
            $0.setImage(UIImage(named: "뒤로가기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(21.0)
        }
        
        topView.addSubview(representBadgeImageView)
        self.representBadgeImageView.then {
            $0.image = UIImage(named: "대표뱃지) 없을 때")
        }.snp.makeConstraints {
            $0.width.height.equalTo(162.0)
            $0.top.equalToSuperview().inset(64.0)
            $0.centerX.equalToSuperview()
        }
        
        topView.addSubview(representBadgeTitleLabel)
        self.representBadgeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.representBadgeImageView.snp.bottom).offset(14.0)
            $0.height.equalTo(19.0)
            $0.centerX.equalToSuperview()
        }
        
        topView.addSubview(representBadgeDescriptionLabel)
        self.representBadgeDescriptionLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
            $0.text = "취향을 기록해 대표 뱃지를 설정해보세요!\n획득조건은 미리 볼 수 있어요."
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(self.representBadgeTitleLabel.snp.bottom).offset(7.2)
            $0.height.equalTo(42.0)
            $0.centerX.equalToSuperview()
        }
        
        let lineView = UIView()
        
        topView.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray02
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.representBadgeDescriptionLabel.snp.bottom).offset(22.2)
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(badgeCollectionView)
        self.badgeCollectionView.then {
            $0.register(BadgeCollectionViewCell.self, forCellWithReuseIdentifier: BadgeCollectionViewCell.identifier)
            $0.register(BadgeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BadgeCollectionHeaderView.identifier)
            $0.backgroundColor = .white
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                // TODO: SE 분기처리
                $0.itemSize = CGSize(width: 84.0, height: 115.0)
                $0.minimumLineSpacing = 27.0
                $0.minimumInteritemSpacing = 20.0
            }
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = true
            $0.delegate = self
            $0.dataSource = self
        }.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.equalToSuperview().inset(41.0)
            $0.bottom.equalToSuperview()
//            $0.height.equalTo(825.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.output!.representBadge
            .bind { [weak self] in
                guard let self = self else { return }
                
                if let badge = $0 {
                    self.representBadgeImageView.kf.setImage(with: URL(string: badge.imgUrl), options: [.processor(SVGProcessor())])
                    self.representBadgeTitle = badge.name
                    self.representBadgeDescriptionLabel.text = "\(badge.description ?? "")" + "\n" + "\(badge.reqConditionShort ?? "")"
                } else {
                    self.representBadgeTitle = "비어있어요"
                    self.representBadgeImageView.image = UIImage(named: "대표뱃지) 없을 때")
                    self.representBadgeDescriptionLabel.text = "취향을 기록해 대표 뱃지를 설정해보세요!\n획득조건은 미리 볼 수 있어요."
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.output!.badges
            .bind { [weak self] in
                self?.badgeCountLabel.text = "(\($0.count)/16)"
                self?.badgeCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension BadgeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BadgeCollectionHeaderView.identifier, for: indexPath) as! BadgeCollectionHeaderView
        header.numberLabel.text = "(\(self.viewModel.output!.numberOfBadges.value)/16)"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constants.DeviceWidth, height: 79.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.output!.badges.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeCollectionViewCell.identifier, for: indexPath) as! BadgeCollectionViewCell
        cell.badge = self.viewModel.output!.badges.value[indexPath.item]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let badge = self.viewModel.output!.badges.value[indexPath.item]
        let vc = BadgeBottomSheet()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.contentHeight = 408.0
        vc.badge = badge
        vc.representBadgeCompletion = { [weak self] in
            self?.viewModel.reload()
        }
        self.present(vc, animated: true)
    }
}

final class BadgeBottomSheet: BaseBottomSheetController {
    var badgeNameLabel = UILabel()
    var conditionLabel = UILabel()
    var badgeImageView = UIImageView()
    var descriptionLabel = UILabel()
    
    var representButton = BaseButton()
    var imageSaveButton = BaseButton()
    var writeButton = BaseButton()
    
    var representBadgeCompletion: (() -> Void)?
    
    var badge: Badge? {
        didSet {
            if let badge = badge {
                self.badgeNameLabel.text = badge.name
                self.badgeImageView.kf.setImage(with: URL(string: badge.imgUrl), options: [.processor(SVGProcessor())])
                self.conditionLabel.text = badge.reqConditionShort
                self.descriptionLabel.text = badge.description
                
                self.representButton.isHidden = badge.isBefore
                self.imageSaveButton.isHidden = badge.isBefore
                
                self.writeButton.isHidden = !badge.isBefore
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.cancelButton.isHidden = true
        self.cancelButton.snp.updateConstraints {
            $0.height.equalTo(0.0)
        }
        
        self.contentView.addSubview(badgeNameLabel)
        self.badgeNameLabel.then {
            $0.font = .bold(20.0)
            $0.textColor = .black
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25.0)
            $0.height.equalTo(24.0)
            $0.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(conditionLabel)
        self.conditionLabel.then {
            $0.font = .regular(12.0)
            $0.textColor = .gray04
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.badgeNameLabel.snp.bottom)
            $0.height.equalTo(18.0)
        }
        
        self.contentView.addSubview(badgeImageView)
        self.badgeImageView.then {
            $0.makeCornerRadius(radius: 162.0 / 2.0)
        }.snp.makeConstraints {
            $0.width.height.equalTo(162.0)
            $0.top.equalTo(self.conditionLabel.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(descriptionLabel)
        self.descriptionLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray04
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.height.equalTo(21.0)
            $0.top.equalTo(self.badgeImageView.snp.bottom).offset(20.0)
            $0.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(representButton)
        self.representButton.then {
            $0.setTitle("대표 뱃지로 설정", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .gray04
            $0.makeCornerRadius(radius: 22.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(30.0)
            $0.left.equalToSuperview().inset(39.0)
            $0.width.equalTo(161.0)
            $0.height.equalTo(44.0)
        }
        
        self.contentView.addSubview(imageSaveButton)
        self.imageSaveButton.then {
            $0.setTitle("이미지 저장", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black
            $0.makeCornerRadius(radius: 22.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(30.0)
            $0.right.equalToSuperview().inset(39.0)
            $0.left.equalTo(self.representButton.snp.right).offset(12.0)
            $0.height.equalTo(44.0)
        }
        
        self.contentView.addSubview(writeButton)
        self.writeButton.then {
            $0.setTitle("기록 쓰러가기", for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black
            $0.makeCornerRadius(radius: 22.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(30.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(161.0)
            $0.height.equalTo(44.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.representButton.rx.tap
            .flatMap { _ -> Observable<Bool> in
                return UserServices.updateUser(updatingUser: UpdatingUser(userId: Int((Constants.CurrentToken?.userId ?? "-1")) ?? -1, nickname: Constants.CurrentUser?.nickname ?? "", isAlarmOn: false, badgeRepresent: self.badge?.badgeId ?? "", isMarketingAllowed: true))
            }
            .bind { [weak self] in
                if $0 {
                    self?.representBadgeCompletion?()
                    self?.dismissActionSheet()
                }
            }
            .disposed(by: disposeBag)
        
        self.imageSaveButton
            .rx.tap
            .bind { [weak self] in
                self?.renderViewAsImage()
            }
            .disposed(by: disposeBag)
        
        self.writeButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let mainViewController = MainViewController.makeMainViewController()
                UIApplication.shared.keyWindow?.replaceRootViewController(mainViewController, animated: true, completion: {
                    WriteBottomSheetViewController.showBottomSheet(viewController: mainViewController.viewControllers![1], type: .category, tabBar: mainViewController.tabBar, writeButton: mainViewController.writeButton)
                })
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        self.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
        if !isUp {
            isUp = true
            
            self.contentView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.top.equalTo(self.cancelButton.snp.bottom)
                $0.height.equalTo(self.contentHeight)
            }
            
            self.containerView.snp.remakeConstraints {
                //                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func renderViewAsImage() {
        let viewForCapture = UIView(frame: CGRect(x: 0, y: 0, width: 375.0, height: 375.0))
        let imageview = UIImageView(frame: CGRect(x: 57.0, y: 47.0, width: 262.0, height: 262.0))
        let logo = UIImageView(frame: CGRect(x: 12.0, y: 337.0, width: 59.0, height: 24.0))
        let dateLabel = UILabel()
        
        viewForCapture.addSubview(imageview)
        _ = imageview.then {
            $0.kf.setImage(with: URL(string: badge!.imgUrl), options: [.processor(SVGProcessor())])
            $0.backgroundColor = .clear
        }
        
        viewForCapture.addSubview(logo)
        logo.image = UIImage(named: "오감 로고 고정")
        
        viewForCapture.addSubview(dateLabel)
        _ = dateLabel.then {
            $0.font = .bold(14.0)
            $0.textColor = .gray04
            $0.text = self.badge!.name + " | " + (Date().toString(format: .WriteView) ?? "")
            $0.sizeToFit()
            $0.frame = CGRect(x: 355.0 - $0.frame.width, y: 341.0, width: $0.frame.width, height: 17.0)
        }
        
        _ = viewForCapture.then {
            $0.backgroundColor = .white
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 375.0, height: 375.0))
        let image = renderer.image { ctx in
            viewForCapture.drawHierarchy(in: viewForCapture.bounds, afterScreenUpdates: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self,
                #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            Toast(text: "이미지가 저장되었습니다.").show()
        }
    }
}

final class BadgeCollectionHeaderView: UICollectionReusableView {
    static let identifier = "BadgeCollectionHeaderView"
    
    var titleLabel = UILabel()
    var numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(20.0)
            $0.textColor = .black
            $0.text = "획득한 뱃지"
        }.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalTo(24.0)
        }
        
        self.addSubview(numberLabel)
        self.numberLabel.then {
            $0.font = .semiBold(16.0)
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(16.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
