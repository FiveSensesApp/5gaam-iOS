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

final class PrepareShareViewController: CMViewController {
    private var closeButton = BaseButton()
    private var titleLabel = UILabel()
    var contentTastesView = ContentTastesView()
    
    var customButton = BaseButton()
    var shareButton = BaseButton()
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            view.contentTextView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
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
        
        let tastesView = ContentTastesView()
        self.setPostView(view: tastesView)
        view.addSubview(tastesView)
        let width = Constants.DeviceWidth - 40.0
        tastesView.frame = CGRect(x: 20.0, y: (Constants.DeviceHeight / 2.0) - (width / 2.0), width: width, height: self.contentTastesView.frame.height)
        
        
        view.layoutIfNeeded()
        
        return view.getImage()
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
