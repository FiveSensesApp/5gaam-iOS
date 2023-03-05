//
//  ContentTastesView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/26.
//

import UIKit

import RxSwift
import RxCocoa

class ContentTastesView: UIView {
    var menuButton = BaseButton()
    var senseImageView = UIImageView()
    var keywordLabel = UILabel()
    var contentTextView = UITextView()
    var dateLabel = UILabel()
    var starView = ContentTastesStarView()
    let keywordBackgroundImageView = UIImageView(image: UIImage(named: "키워드배경"))
    var shareButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray01
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(menuButton)
        self.menuButton.then {
            $0.setImage(UIImage(named: "메뉴(공유,수정,삭제)"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.right.equalToSuperview()
            $0.top.equalToSuperview().inset(14.0)
        }
        
        self.addSubview(self.shareButton)
        self.shareButton.then {
            $0.setImage(UIImage(named: "공유 버튼")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.top.equalTo(self.menuButton)
            $0.right.equalTo(self.menuButton.snp.left)
        }
        
        self.addSubview(senseImageView)
        self.senseImageView.then {
            $0.contentMode = .scaleAspectFill
        }.snp.makeConstraints {
            $0.width.height.equalTo(66.0)
            $0.left.equalToSuperview().inset(14.0)
            $0.top.equalToSuperview().inset(57.0)
        }
        
        self.addSubview(keywordBackgroundImageView)
        keywordBackgroundImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(14.0)
            $0.height.equalTo(48.0)
            $0.left.equalTo(self.senseImageView.snp.right).offset(-6.0)
            $0.centerY.equalTo(self.senseImageView)
        }
        
        self.addSubview(keywordLabel)
        self.keywordLabel.then {
            $0.font = .bold(16.0)
            $0.textColor = .black
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.right.centerY.equalTo(keywordBackgroundImageView)
            $0.left.equalTo(keywordBackgroundImageView).inset(14.0)
        }
        
        self.addSubview(contentTextView)
        self.contentTextView.then {
            $0.backgroundColor = .white
            $0.makeCornerRadius(radius: 10.0)
            $0.textAlignment = .left
            $0.textColor = .gray04
            $0.font = .medium(14.0)
            $0.isUserInteractionEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 14.0, right: 14.0)
        }.snp.makeConstraints {
            $0.height.equalTo(134.0)
            $0.left.right.equalToSuperview().inset(14.0)
            $0.top.equalTo(self.senseImageView.snp.bottom).offset(8.0)
        }
        
        self.addSubview(dateLabel)
        self.dateLabel.then {
            $0.font = .medium(14.0)
        }.snp.makeConstraints {
            $0.height.equalTo(20.0)
            $0.left.equalToSuperview().inset(24.0)
            $0.top.equalTo(self.contentTextView.snp.bottom).offset(18.0)
        }
        
        self.addSubview(starView)
        self.starView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(18.0)
            $0.height.equalTo(34.0)
            $0.top.equalTo(self.contentTextView.snp.bottom).offset(10.0)
            $0.bottom.equalToSuperview().inset(26.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ContentTastesViewForShare: ContentTastesView {
    var logoImageView = UIImageView()
    var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 0
        
        self.menuButton.removeFromSuperview()
        
        self.keywordLabel.font = .bold(10.34)
        self.contentTextView.font = .medium(9.05)
        
        self.senseImageView.snp.updateConstraints {
            $0.width.height.equalTo(47.28)
            $0.left.equalToSuperview().inset(7.22)
            $0.top.equalToSuperview().inset(35.46)
        }
        
        self.keywordBackgroundImageView.snp.updateConstraints {
            $0.right.equalToSuperview().inset(9.19)
            $0.height.equalTo(31.52)
            $0.left.equalTo(self.senseImageView.snp.right).offset(-3.94)
            $0.centerY.equalTo(self.senseImageView)
        }
        
        self.contentTextView.snp.updateConstraints {
            $0.height.equalTo(88.0)
            $0.left.right.equalToSuperview().inset(9.2)
            $0.top.equalTo(self.senseImageView.snp.bottom).offset(3.29)
        }
        
        self.dateLabel.then {
            $0.font = .medium(7.75)
        }.snp.updateConstraints {
            $0.height.equalTo(12.19)
            $0.left.equalToSuperview().inset(15.76)
            $0.top.equalTo(self.contentTextView.snp.bottom).offset(12.48)
        }
        
        self.addSubview(self.logoImageView)
        self.logoImageView.then {
            $0.image = UIImage(named: "오감-영문세로")?.withRenderingMode(.alwaysTemplate)
        }.snp.makeConstraints {
            $0.width.equalTo(47.41)
            $0.height.equalTo(18.39)
            $0.top.equalToSuperview().inset(19.04)
            $0.right.equalToSuperview().inset(9.01)
        }
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.dateLabel)
            $0.right.equalToSuperview().inset(16.27)
        }
        
        self.starView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DetailTastesViewController: UIViewController {
    var tastePost: Post? {
        didSet {
            setPostView()
        }
    }
    var contentTastesView = ContentTastesView()
    var backgroundView = UIView()
    var postMenuView = PostMenuView()
    
    private var disposeBag = DisposeBag()
    var isPostMenuOpen = false
    
    private var closeButton = BaseButton()
    
    var postArray: [Post] = [] {
        didSet {
            self.changedPostArray.accept(self.postArray)
        }
    }
    lazy var changedPostArray = BehaviorRelay<[Post]>(value: self.postArray)
    
    convenience init(post: Post) {
        self.init()
        self.tastePost = post
    }
    
    override func loadView() {
        self.view = UIView()
        
        self.setPostView()
        
        self.view.addSubview(backgroundView)
        self.backgroundView.backgroundColor = UIColor(hex: "000000", alpha: 0.7)
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.view.addSubview(contentTastesView)
       
        
        self.contentTastesView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
        }
        
        self.contentTastesView.addSubview(closeButton)
        self.closeButton.then {
            $0.setImage(UIImage(named: "개별 키워드 닫기"), for: .normal)
        }.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.top.equalToSuperview().inset(17.0)
            $0.left.equalToSuperview().inset(11.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.closeButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.contentTastesView.menuButton
            .rx.tap
            .bind { [weak self] in
                self?.showPostMenu()
            }
            .disposed(by: disposeBag)
        
        self.postMenuView.deleteButtonTapped
            .asObservable()
            .bind { [weak self] _ in
                self?.dismissPostMenu()
                self?.showDeleteAlert()
            }
            .disposed(by: disposeBag)
        
        self.postMenuView.modifyButtonTapped
            .asObservable()
            .bind { [weak self] _ in
                guard let self = self else { return }
                let vc = ModifyPostViewController()
                vc.dismissCompletion = {
                    if let index = self.postArray.firstIndex(where: { $0.id == self.tastePost?.id }) {
                        self.tastePost = $0
                        self.postArray[index] = $0
                    }
                }
                vc.currentPost = self.postMenuView.post
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                self.dismissPostMenu()
            }
            .disposed(by: disposeBag)
        
        self.contentTastesView.shareButton.isHidden = false
        self.contentTastesView.shareButton
            .rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }

                let prepareShareViewController = PrepareShareViewController()
                prepareShareViewController.tastePost = self.tastePost
                let navigationController = CMNavigationController(rootViewController: prepareShareViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)

            }
            .disposed(by: disposeBag)
    }
    
    private func setPostView() {
        guard let tastePost = self.tastePost else { return }
        
        self.contentTastesView.menuButton.setImage(UIImage(named: "메뉴(공유,수정,삭제)")?.withTintColor(tastePost.category.color), for: .normal)
        self.contentTastesView.senseImageView.image = tastePost.category.characterImage
        self.contentTastesView.dateLabel.textColor = tastePost.category.color
        self.contentTastesView.dateLabel.text = tastePost.createdDate.toString(format: .WriteView)
        self.contentTastesView.starView.setStar(score: tastePost.star, sense: tastePost.category)
        
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
    
    func showPostMenu() {
        guard !isPostMenuOpen else {
            self.dismissPostMenu()
            return
        }
        
        let menuButtonFrame = self.contentTastesView.frame
        
        self.postMenuView.post = tastePost
        self.postMenuView.removeFromSuperview()
        isPostMenuOpen = true
        
        postMenuView.frame = CGRect(
            x: menuButtonFrame.maxX - 126.0,
            y: menuButtonFrame.origin.y + 58.0,
            width: 112.0,
            height: 102.0
        )
        
        self.view.addSubview(postMenuView)
    }
    
    func dismissPostMenu() {
        if self.isPostMenuOpen {
            self.postMenuView.removeFromSuperview()
            self.isPostMenuOpen = false
        }
    }
    
    private func showDeleteAlert() {
        self.view.endEditing(true)
        
        let alert = TwoButtonAlertController(title: "정말 삭제하시겠어요?", content: "삭제한 취향은 복구할 수 없어요.", okButtonTitle: "뒤로 가기", cancelButtonTitle: "삭제 하기")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        alert.okButton.rx.tap
            .bind {
                alert.dismiss(animated: true)
            }.disposed(by: disposeBag)
        alert.cancelButton.rx.tap
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self, let post = self.postMenuView.post else { return Observable.just(false) }
                
                return PostServices.deletePost(post: post)
            }
            .bind { [weak self] in
                guard let self = self, let post = self.postMenuView.post  else { return }
                if $0 {
                    
                    if let index = self.postArray.firstIndex(where: {
                        post.id == $0.id
                    }) {
                        self.postArray.remove(at: index)
                    }
                    
                    self.dismissPostMenu()
                    alert.dismiss(animated: true)
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        self.present(alert, animated: true)
    }
}

