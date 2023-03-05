//
//  PrepareShareViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/11/28.
//

import UIKit

import RxSwift
import RxCocoa
import EmojiPicker
import PhotosUI
import FSPagerView
import SwiftyUserDefaults

enum SharePostRatioType {
    case by11
    case by169
}

final class PrepareShareViewController: CMViewController {
    private var closeButton = BaseButton()
    private var titleLabel = UILabel()
    var pagerView = FSPagerView()
    
    var shareButton = BaseButton()
    
    let imagePicker = UIImagePickerController()
    
    var configuration = PHPickerConfiguration()
    
    var tastePost: Post? {
        didSet {
            if let tastePost {
                self.setPostView(tastePost: tastePost)
            }
        }
    }
    
    var iconCustomView = UIView()
    var characterButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
    }
    var emojiButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
    }
    var textOnlyButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
    }
    
    var contentTastesView = ContentTastesViewForShare()
    
    var backgroundImage: UIImage? = nil {
        didSet {
            self.pagerView.reloadData()
            self.shareButton.isEnabled = (self.backgroundImage != nil)
        }
    }
    
    private var isFirst = true
    
    private var onboardingImageView = UIImageView()
    private var onboardingCount = 0
    
    var addBackgroundImageBalloon = UIButton()
    
    var currentType: CustomIconType? {
        didSet {
            if let currentType {
                switch currentType {
                case .character:
                    self.characterButton.setImage(UIImage(named: "오감캐릭터) 선택 O"), for: .normal)
                    self.emojiButton.setImage(UIImage(named: "이모지) 선택 X"), for: .normal)
                    self.textOnlyButton.setImage(UIImage(named: "텍스트만) 선택 X"), for: .normal)
                case .emoji:
                    self.characterButton.setImage(UIImage(named: "오감캐릭터) 선택 X"), for: .normal)
                    self.emojiButton.setImage(UIImage(named: "이모지) 선택 O"), for: .normal)
                    self.textOnlyButton.setImage(UIImage(named: "텍스트만) 선택 X"), for: .normal)
                case .textOnly:
                    self.characterButton.setImage(UIImage(named: "오감캐릭터) 선택 X"), for: .normal)
                    self.emojiButton.setImage(UIImage(named: "이모지) 선택 X"), for: .normal)
                    self.textOnlyButton.setImage(UIImage(named: "텍스트만) 선택 O"), for: .normal)
                }
                
                self.contentTastesView.keywordLabel.backgroundColor = .white
                self.contentTastesView.keywordLabel.makeCornerRadius(radius: 10.0)
                self.contentTastesView.keywordLabel.snp.remakeConstraints {
                    $0.right.centerY.equalTo(self.contentTastesView.keywordBackgroundImageView)
                    $0.left.equalTo(self.contentTastesView.keywordBackgroundImageView).inset(14.0)
                }
    
                switch currentType {
                case .character:
                    self.contentTastesView.senseImageView.image = tastePost?.category.characterImage
                case .emoji(let emoji):
                    self.contentTastesView.senseImageView.image = emoji.image()
                case .textOnly:
                    self.contentTastesView.keywordLabel.snp.remakeConstraints {
                        $0.left.right.equalToSuperview().inset(14.0)
                        $0.height.equalTo(31.52)
                        $0.centerY.equalTo(self.contentTastesView.keywordBackgroundImageView)
                    }
                    self.contentTastesView.senseImageView.image = nil
                }
                self.contentTastesView.setNeedsLayout()
                self.pagerView.reloadData()
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        self.currentType = .character
        
        self.navigationBarView.snp.remakeConstraints {
            $0.height.equalTo(0)
            $0.top.left.right.equalToSuperview()
        }
        
        
        self.view.addSubview(closeButton)
        self.closeButton.then {
            $0.setImage(UIImage(named: "뒤로가기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview().inset(44.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.view.addSubview(titleLabel)
        self.titleLabel.then {
            $0.text = "미리보기"
            $0.font = .bold(26.0)
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(21.0)
            $0.top.equalTo(self.closeButton.snp.bottom).offset(25.0)
            $0.height.equalTo(31.0)
        }
        
        self.view.addSubview(self.pagerView)
        self.pagerView.then {
            $0.isInfinite = false
            $0.register(ShareContentPagerCell.self, forCellWithReuseIdentifier: ShareContentPagerCell.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.itemSize = CGSize(width: 220.0, height: 320.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(31.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(320.0)
        }
        
        self.view.addSubview(shareButton)
        self.shareButton.then {
            $0.makeCornerRadius(radius: 19.0)
            $0.isEnabled = true
            $0.setBackgroundImage(UIImage.color(UIColor.black), for: .normal)
            $0.setBackgroundImage(UIImage.color(UIColor.gray03), for: .disabled)
            $0.setTitle("공유", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
        }.snp.makeConstraints {
            $0.centerY.equalTo(self.closeButton)
            $0.width.equalTo(74.0)
            $0.height.equalTo(38.0)
            $0.right.equalToSuperview().inset(21.0)
        }
        
        self.view.addSubview(self.iconCustomView)
        self.iconCustomView.then {
            $0.backgroundColor = .white
        }.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(221.0)
        }
        
        self.view.addSubview(self.addBackgroundImageBalloon)
        self.addBackgroundImageBalloon.then {
            $0.setImage(UIImage(named: "BackgroundAddBalloon"), for: .normal)
            $0.isHidden = true
            $0.adjustsImageWhenHighlighted = false
        }.snp.makeConstraints {
            $0.width.equalTo(288.0)
            $0.height.equalTo(49.88)
            $0.top.equalTo(self.pagerView.snp.bottom).offset(15.0)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.onboardingImageView)
        self.onboardingImageView.then {
            $0.image = UIImage(named: "공유 가이드 1")
            $0.contentMode = .scaleAspectFit
//            $0.isHidden = Defaults[\.didSeenShareOnBoarding]
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard self.isFirst else { return }
        
        self.isFirst = false
        
        self.iconCustomView.addShadow(shadowColor: .lightGray, offSet: CGSize(width: 0, height: 10.0), opacity: 0.5, shadowRadius: 10.0, cornerRadius: 30.0, corners: [.topRight, .topLeft])
        
        let bottomTitleLabel = UILabel()
        self.iconCustomView.addSubview(bottomTitleLabel)
        bottomTitleLabel.then {
            $0.textColor = .black
            $0.font = .bold(20.0)
            $0.text = "아이콘 커스텀"
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.centerX.equalToSuperview()
        }
        
        let subtitleLabel = UILabel()
        self.iconCustomView.addSubview(subtitleLabel)
        subtitleLabel.then {
            $0.textColor = .gray04
            $0.font = .regular(12.0)
            $0.text = "취향에 맞게 아이콘을 변경해 보세요."
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(bottomTitleLabel.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [characterButton, emojiButton, textOnlyButton])
        self.iconCustomView.addSubview(buttonStackView)
        buttonStackView.then {
            $0.axis = .horizontal
            $0.spacing = 10.0
            $0.distribution = .fillEqually
        }.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(26.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(71.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        self.closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.shareButton.rx.tap
            .bind { [weak self] in
                self?.shareButtonTapped()
            }
            .disposed(by: disposeBag)
        
        self.characterButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.currentType = .character
            }
            .disposed(by: self.disposeBag)
        
        self.emojiButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.presentEmojiSelectController()
            }
            .disposed(by: disposeBag)
        
        self.textOnlyButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.currentType = .textOnly
            }
            .disposed(by: disposeBag)
        
        self.onboardingImageView
            .rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self else { return }
                
                if self.onboardingCount == 2 {
                    self.onboardingImageView.isHidden = true
//                    Defaults[\.didSeenShareOnBoarding] = true
                }
                
                self.onboardingCount += 1
                self.onboardingImageView.image = UIImage(named: "공유 가이드 \(self.onboardingCount + 1)")
            }
            .disposed(by: disposeBag)
        
        self.addBackgroundImageBalloon
            .rx.tap
            .bind { [weak self] _ in
                guard let self else { return }
                
                let alert = UIAlertController(title: "선택", message: nil, preferredStyle: .actionSheet)
                let library = UIAlertAction(title: "앨범", style: .default) { action in
                    self.openLibrary()
                }
                let camera = UIAlertAction(title: "카메라", style: .default) { action in
                    self.openCamera()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alert.addAction(library)
                alert.addAction(camera)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func presentEmojiSelectController() {
        let configuration = EmojiPicker.Configuration(sourceViewController: self, sender: emojiButton, arrowDirection: .down)
        EmojiPicker.present(with: configuration)
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)
    }
    
    private func openLibrary() {
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func shareButtonTapped() {
        guard let renderedImage = self.renderViewAsImage() else { return }
        let activityVC = UIActivityViewController(activityItems: [renderedImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func renderViewAsImage() -> UIImage? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.DeviceWidth, height: Constants.DeviceHeight))
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.image = self.contentTastesView.asImage()
        }
        
        if self.pagerView.currentIndex == 0 {
            view.addSubview(imageView)
            let viewWidth = Constants.DeviceWidth - 24.0
            imageView.frame = CGRect(x: 12.0, y: (Constants.DeviceHeight / 2.0) - (viewWidth / 2.0), width: viewWidth, height: viewWidth)
        } else {
            let backgroundImageView = UIImageView().then {
                $0.contentMode = .scaleAspectFill
                $0.image = self.backgroundImage
            }
            
            view.addSubview(backgroundImageView)
            backgroundImageView.frame = view.frame
            
            view.addSubview(imageView)
            let viewWidth = Constants.DeviceWidth - 42.0
            imageView.frame = CGRect(x: 21.0, y: (Constants.DeviceHeight / 2.0) - (viewWidth / 2.0), width: viewWidth, height: viewWidth)
        }
        
        view.setNeedsLayout()
        
        return view.asImage()
    }
    
    private func setPostView(tastePost: Post) {
        
        self.contentTastesView.logoImageView.tintColor = tastePost.category.color
        
        let string = NSMutableAttributedString(string: "\(Constants.CurrentUser?.nickname ?? "")", attributes: [.font: UIFont.bold(7.75), .foregroundColor: UIColor.gray04])
        let string2 = NSMutableAttributedString(string: "님의", attributes: [.font: UIFont.regular(7.75), .foregroundColor: UIColor.gray04])
        let string3 = NSMutableAttributedString(string: " '\(tastePost.category.name)'", attributes: [.font: UIFont.bold(7.75), .foregroundColor: tastePost.category.color])
        let string4 = NSMutableAttributedString(string: "으로 감각한 취향", attributes: [.font: UIFont.regular(7.75), .foregroundColor: UIColor.gray04])
        
        string.append(string2)
        string.append(string3)
        string.append(string4)
        
        self.contentTastesView.descriptionLabel.attributedText = string
        
        self.contentTastesView.senseImageView.image = tastePost.category.characterImage
        self.contentTastesView.dateLabel.textColor = tastePost.category.color
        self.contentTastesView.dateLabel.text = tastePost.createdDate.toString(format: .WriteView)
        self.contentTastesView.keywordLabel.text = tastePost.keyword
        self.contentTastesView.contentTextView.text = tastePost.content
        
        if tastePost.content == "" {
            self.contentTastesView.contentTextView.isHidden = true
            self.contentTastesView.contentTextView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            self.contentTastesView.contentTextView.snp.updateConstraints {
                $0.height.equalTo(88.0)
            }
        }
    }
}

extension PrepareShareViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.backgroundImage = image
            dismiss(animated: true)
        }
    }
}

extension PrepareShareViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.sync { [weak self] in
                    self?.backgroundImage = image as? UIImage
                }
            }
        }
    }
}

extension PrepareShareViewController: EmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        self.currentType = .emoji(emoji: emoji)
    }
}

extension PrepareShareViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let tastePost else { return FSPagerViewCell() }
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ShareContentPagerCell.identifier, at: index) as! ShareContentPagerCell
        
        if index == 0 {
            cell.configure(contentTasteView: self.contentTastesView, post: tastePost, ratio: .by11)
        } else {
            cell.configure(contentTasteView: self.contentTastesView, post: tastePost, ratio: .by169)
            
            if let backgroundImage {
                cell.backgroundImageView.image = backgroundImage
            } else {
                cell.backgroundImageView.image = UIImage(named: "모눈")
            }
            
            cell.addBackgroundImageButton.rx.tap
                .bind { [weak self] _ in
                    guard let self else { return }
                    
                    let alert = UIAlertController(title: "선택", message: nil, preferredStyle: .actionSheet)
                    let library = UIAlertAction(title: "앨범", style: .default) { action in
                        self.openLibrary()
                    }
                    let camera = UIAlertAction(title: "카메라", style: .default) { action in
                        self.openCamera()
                    }
                    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    
                    alert.addAction(library)
                    alert.addAction(camera)
                    alert.addAction(cancel)
                    
                    self.present(alert, animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        
        return cell
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        if pagerView.currentIndex == 0 {
            self.shareButton.isEnabled = true
            self.addBackgroundImageBalloon.isHidden = true
        } else {
            self.shareButton.isEnabled = (self.backgroundImage != nil)
            self.addBackgroundImageBalloon.isHidden = false
        }
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        self.addBackgroundImageBalloon.isHidden = true
    }
}

final class CustomBottomSheetViewController: BaseBottomSheetController {
    
    
    weak var viewController: PrepareShareViewController?
    
    var currentType: CustomIconType? {
        didSet {
            if let currentType {
                switch currentType {
                case .character:
                    self.characterButton.setImage(UIImage(named: "오감캐릭터) 선택 O"), for: .normal)
                    self.emojiButton.setImage(UIImage(named: "이모지) 선택 X"), for: .normal)
                    self.textOnlyButton.setImage(UIImage(named: "텍스트만) 선택 X"), for: .normal)
                case .emoji:
                    self.characterButton.setImage(UIImage(named: "오감캐릭터) 선택 X"), for: .normal)
                    self.emojiButton.setImage(UIImage(named: "이모지) 선택 O"), for: .normal)
                    self.textOnlyButton.setImage(UIImage(named: "텍스트만) 선택 X"), for: .normal)
                case .textOnly:
                    self.characterButton.setImage(UIImage(named: "오감캐릭터) 선택 X"), for: .normal)
                    self.emojiButton.setImage(UIImage(named: "이모지) 선택 X"), for: .normal)
                    self.textOnlyButton.setImage(UIImage(named: "텍스트만) 선택 O"), for: .normal)
                }
            }
        }
    }
    
    var characterButton = UIButton()
    var emojiButton = UIButton()
    var textOnlyButton = UIButton()
    
    override func loadView() {
        super.loadView()
        
        self.cancelButton.isHidden = true
        self.view.backgroundColor = .white.withAlphaComponent(0.8)
        
        self.titleLabel.text = "아이콘 커스텀"
        self.titleLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(29.0)
            $0.centerX.equalToSuperview()
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [characterButton, emojiButton, textOnlyButton])
        self.contentView.addSubview(buttonStackView)
        buttonStackView.then {
            $0.axis = .horizontal
            $0.spacing = 10.0
        }.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(71.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characterButton.rx.tap
            .bind { [weak self] in
                guard let self, let viewController = self.viewController else { return }
                self.currentType = .character
                viewController.currentType = .character
            }
            .disposed(by: disposeBag)
        
        self.emojiButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.presentEmojiSelectController()
            }
            .disposed(by: disposeBag)
        
        self.textOnlyButton.rx.tap
            .bind { [weak self] in
                guard let self, let viewController = self.viewController else { return }
                self.currentType = .textOnly
                viewController.currentType = .textOnly
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        self.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
        if !isUp {
            self.containerView.layoutIfNeeded()
            isUp = true
            
            self.contentView.snp.remakeConstraints {
                $0.left.right.equalToSuperview().inset(21.0)
                $0.bottom.equalToSuperview()
                $0.top.equalTo(self.titleLabel.snp.bottom).offset(31.0)
                $0.height.equalTo(167.0)
            }
            
            self.containerView.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController != self {
                return
            }
        }
        
        let touch: UITouch? = touches.first
        
        if let touchView = touch?.view,
           touchView != containerView
            && self.isBackgroundDismissOn {
            self.dismissActionSheet()
        }
    }
    
    private func presentEmojiSelectController() {
        let configuration = EmojiPicker.Configuration(sourceViewController: self, sender: emojiButton, arrowDirection: .down)
        EmojiPicker.present(with: configuration)
    }
}

extension CustomBottomSheetViewController: EmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        self.currentType = .emoji(emoji: emoji)
        self.viewController?.currentType = .emoji(emoji: emoji)
    }
}

enum CustomIconType {
    case character
    case emoji(emoji: String)
    case textOnly
}
