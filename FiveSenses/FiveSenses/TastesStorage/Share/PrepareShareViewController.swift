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

final class PrepareShareViewController: CMViewController {
    private var closeButton = BaseButton()
    private var titleLabel = UILabel()
    var contentTastesView = ContentTastesView()
    
    var customButton = BaseButton()
    var shareButton = BaseButton()
    var backgroundImageView = UIImageView()
    var backgroundImageAddView = UIView()
    private var plusImageView = UIImageView()
    private var backgroundImageAddLabel = UILabel()
    
    let imagePicker = UIImagePickerController()
    
    var configuration = PHPickerConfiguration()
    
    var tastePost: Post? {
        didSet {
            setPostView()
        }
    }
    
    private var disposeBag = DisposeBag()
    var currentType: CustomIconType = .character {
        didSet {
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
                self.contentTastesView.senseImageView.image = nil
                self.contentTastesView.keywordLabel.snp.remakeConstraints {
                    $0.left.right.equalToSuperview().inset(14.0)
                    $0.height.equalTo(48.0)
                    $0.centerY.equalTo(self.contentTastesView.keywordBackgroundImageView)
                }
            }
            
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.snp.remakeConstraints {
            $0.height.equalTo(0)
            $0.top.left.right.equalToSuperview()
        }
        
        self.view.addSubview(backgroundImageView)
        self.backgroundImageView.then {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .clear
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        self.view.addSubview(contentTastesView)
        self.contentTastesView.then {
            $0.addShadow(offset: CGSize(width: 0, height: 5))
            $0.menuButton.isHidden = true
            $0.starView.removeFromSuperview()
            $0.senseImageView.contentMode = .scaleAspectFit
            $0.dateLabel.snp.remakeConstraints {
                $0.height.equalTo(20.0)
                $0.left.equalToSuperview().inset(24.0)
                $0.top.equalTo(self.contentTastesView.contentTextView.snp.bottom).offset(18.0)
                $0.bottom.equalToSuperview().inset(33.0)
            }
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(24.0)
        }
        
        self.view.addSubview(customButton)
        self.customButton.then {
            $0.makeCornerRadius(radius: 22.5)
            $0.backgroundColor = .gray03
            $0.setTitle("커스텀하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
        }.snp.makeConstraints {
            $0.height.equalTo(44.0)
            $0.width.equalTo(124.0)
            $0.right.equalTo(self.view.snp.centerX).offset(-8.0)
            $0.top.equalTo(self.contentTastesView.snp.bottom).offset(38.0)
        }
        
        self.view.addSubview(shareButton)
        self.shareButton.then {
            $0.makeCornerRadius(radius: 22.5)
            $0.backgroundColor = .gray04
            $0.setTitle("공유하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
        }.snp.makeConstraints {
            $0.height.equalTo(44.0)
            $0.width.equalTo(124.0)
            $0.left.equalTo(self.view.snp.centerX).offset(8.0)
            $0.top.equalTo(self.contentTastesView.snp.bottom).offset(38.0)
        }
        
        self.view.addSubview(backgroundImageAddView)
        self.backgroundImageAddView.then {
            $0.layer.borderColor = UIColor.gray03.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 17.0
            $0.layer.masksToBounds = true
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(self.titleLabel)
            $0.width.equalTo(104.0)
            $0.height.equalTo(34.0)
        }
        
        self.backgroundImageAddView.addSubview(plusImageView)
        self.plusImageView.then {
            $0.image = UIImage(named: "배경추가")
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(11.0)
        }
        
        self.backgroundImageAddView.addSubview(backgroundImageAddLabel)
        self.backgroundImageAddLabel.then {
            $0.font = .semiBold(16.0)
            $0.text = "배경 추가"
            $0.textColor = .gray04
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12.0)
            $0.centerY.equalToSuperview()
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
        
        self.customButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let bottomSheet = CustomBottomSheetViewController()
                bottomSheet.modalPresentationStyle = .overFullScreen
                bottomSheet.currentType = self.currentType
                bottomSheet.viewController = self
                self.present(bottomSheet, animated: false)
            }
            .disposed(by: disposeBag)
        
        self.shareButton.rx.tap
            .bind { [weak self] in
                self?.shareButtonTapped()
            }
            .disposed(by: disposeBag)
        
        self.backgroundImageAddView
            .rx.tapGesture()
            .when(.recognized)
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
            .disposed(by: disposeBag)
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
    
    private func setPostView() {
        guard let tastePost = self.tastePost else { return }
        
        let logoImageView = UIImageView(image: UIImage(named: "오감-영문세로"))
        logoImageView.tintColor = tastePost.category.color
        self.contentTastesView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29.0)
            $0.right.equalToSuperview().inset(14.0)
        }
        
        let descriptionLabel = UILabel()
        self.contentTastesView.addSubview(descriptionLabel)
        descriptionLabel.then {
            let string = NSMutableAttributedString(string: "\(Constants.CurrentUser?.nickname ?? "")", attributes: [.font: UIFont.bold(12.0), .foregroundColor: UIColor.gray04])
            let string2 = NSMutableAttributedString(string: "님의", attributes: [.font: UIFont.regular(12.0), .foregroundColor: UIColor.gray04])
            let string3 = NSMutableAttributedString(string: " '\(tastePost.category.name)'", attributes: [.font: UIFont.bold(12.0), .foregroundColor: tastePost.category.color])
            let string4 = NSMutableAttributedString(string: "으로 감각한 취향", attributes: [.font: UIFont.regular(12.0), .foregroundColor: UIColor.gray04])
            
            string.append(string2)
            string.append(string3)
            string.append(string4)
            
            $0.attributedText = string
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24.0)
            $0.centerY.equalTo(self.contentTastesView.dateLabel)
        }
        
        self.contentTastesView.senseImageView.image = tastePost.category.characterImage
        self.contentTastesView.dateLabel.textColor = tastePost.category.color
        self.contentTastesView.dateLabel.text = tastePost.createdDate.toString(format: .WriteView)
        self.contentTastesView.keywordLabel.text = tastePost.keyword
        self.contentTastesView.contentTextView.text = tastePost.content
        
        if tastePost.content == "" {
            self.contentTastesView.contentTextView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            self.contentTastesView.contentTextView.snp.updateConstraints {
                $0.height.equalTo(134.0)
            }
        }
    }
    
    private func setPostView(view: ContentTastesView) {
        guard let tastePost = self.tastePost else { return }
        
        view.addShadow(offset: CGSize(width: 0, height: 5))
        view.menuButton.isHidden = true
        view.starView.removeFromSuperview()
        view.senseImageView.contentMode = .scaleAspectFit
        
        let logoImageView = UIImageView(image: UIImage(named: "오감-영문세로"))
        logoImageView.tintColor = tastePost.category.color
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29.0)
            $0.right.equalToSuperview().inset(14.0)
        }
        
        let descriptionLabel = UILabel()
        view.addSubview(descriptionLabel)
        descriptionLabel.then {
            let string = NSMutableAttributedString(string: "\(Constants.CurrentUser?.nickname ?? "")", attributes: [.font: UIFont.bold(12.0), .foregroundColor: UIColor.gray04])
            let string2 = NSMutableAttributedString(string: "님의", attributes: [.font: UIFont.regular(12.0), .foregroundColor: UIColor.gray04])
            let string3 = NSMutableAttributedString(string: " '\(tastePost.category.name)'", attributes: [.font: UIFont.bold(12.0), .foregroundColor: tastePost.category.color])
            let string4 = NSMutableAttributedString(string: "으로 감각한 취향", attributes: [.font: UIFont.regular(12.0), .foregroundColor: UIColor.gray04])
            
            string.append(string2)
            string.append(string3)
            string.append(string4)
            
            $0.attributedText = string
        }.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24.0)
            $0.centerY.equalTo(view.dateLabel)
        }
        
        switch currentType {
        case .character:
            view.senseImageView.image = tastePost.category.characterImage
        case .emoji(let emoji):
            view.senseImageView.image = emoji.image()
        case .textOnly:
            view.keywordLabel.backgroundColor = .white
            view.keywordLabel.makeCornerRadius(radius: 10.0)
            view.senseImageView.image = nil
            view.keywordLabel.snp.remakeConstraints {
                $0.left.right.equalToSuperview().inset(14.0)
                $0.height.equalTo(48.0)
                $0.centerY.equalTo(view.keywordBackgroundImageView)
            }
        }
        
        view.dateLabel.textColor = tastePost.category.color
        view.dateLabel.text = tastePost.createdDate.toString(format: .WriteView)
        view.keywordLabel.text = tastePost.keyword
        view.contentTextView.text = tastePost.content
        
        if tastePost.content == "" {
            view.contentTextView.backgroundColor = .gray01
            view.contentTextView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            view.contentTextView.backgroundColor = .white
            view.contentTextView.snp.updateConstraints {
                $0.height.equalTo(134.0)
            }
        }
    }
    
    private func shareButtonTapped() {
        guard let renderedImage = self.renderViewAsImage() else { return }
        let activityVC = UIActivityViewController(activityItems: [renderedImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func renderViewAsImage() -> UIImage? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.DeviceWidth, height: Constants.DeviceHeight))
        
        let backgroundImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.image = self.backgroundImageView.image
            $0.backgroundColor = .white
        }
        
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: Constants.DeviceWidth, height: Constants.DeviceHeight)
        
        let tastesView = ContentTastesView()
        self.setPostView(view: tastesView)
        view.addSubview(tastesView)
        let width = Constants.DeviceWidth - 40.0
        tastesView.frame = CGRect(x: 20.0, y: (Constants.DeviceHeight / 2.0) - (width / 2.0), width: width, height: self.contentTastesView.frame.height)
        
        
        view.layoutIfNeeded()
        
        return view.getImage()
    }
}

extension PrepareShareViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.backgroundImageView.image = image
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
                DispatchQueue.main.sync {
                    self.backgroundImageView.image = image as? UIImage
                }
            }
        }
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
