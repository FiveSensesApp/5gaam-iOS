//
//  ModifyPostViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/04.
//

import UIKit

import RxSwift
import RxCocoa

class ModifyPostViewController: CMViewController {
    var currentPost: Post?
    
    var writeView = WriteTastesView()
    var finishButton = BaseButton()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.snp.remakeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.0)
        }
        
        self.writeView = WriteTastesView(sense: self.currentPost!.category)
        self.writeView.selectedSenseImageView.isHidden = true
        
        self.contentView.addSubview(writeView)
        self.writeView.backImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        self.writeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.writeView.backImageView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(44.0)
        }
        
        self.writeView.addSubview(finishButton)
        self.finishButton.then {
            $0.backgroundColor = .black
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .bold(18.0)
            $0.makeCornerRadius(radius: 19.0)
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44.0)
            $0.right.equalToSuperview().inset(21.0)
            $0.width.equalTo(74.0)
            $0.height.equalTo(38.0)
        }
        
        self.setPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.finishButton
            .rx.tap
            .flatMap { [weak self] _ -> Observable<Post?> in
                guard let self = self, let post = self.currentPost else { return Observable.just(nil) }
                
                let creatingPost = CreatingPost(
                    category: post.category,
                    keyword: self.writeView.keywordTextField.text ?? "",
                    star: self.writeView.starView.score,
                    content: self.writeView.memoTextView.text
                )
                
                return PostServices.modifyPost(id: post.id, creatingPost: creatingPost)
            }
            .bind { [weak self] in
                if $0 != nil {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setPost() {
        guard let post = currentPost else { return }
        
        let modifiedDate = post.modifiedDate.toString(format: .ModifyPost) ?? ""
        let sense = post.category
        
        self.writeView.dateLabel.text = post.modifiedDate.toString(format: .WriteView)
        
        var name = sense.name
        var footer = "\n\(modifiedDate)의 취향 수정,"
        
        if sense == .dontKnow {
            name = "감각"
            footer = "이 정해지기 전인" + footer
        } else {
            footer = "으로 감각한" + footer
        }
        
        let string = NSMutableAttributedString(string: name, attributes: [.font: UIFont.bold(26.0), .foregroundColor: sense.color])
        string.append(NSMutableAttributedString(string: footer, attributes: [.font: UIFont.bold(26.0), .foregroundColor: UIColor.black]))
        
        self.writeView.titleLabel.attributedText = string
        self.writeView.backImageView.image = sense.backButtonImage
        self.writeView.keywordTextField.text = post.keyword
        
        self.writeView.starView.score = post.star
        for button in self.writeView.starView.buttons {
            button.setImage(sense.star(isEmpty: true), for: .normal)
        }
        for i in 0...(post.star - 1) {
            self.writeView.starView.buttons[i].setImage(sense.star(isEmpty: false), for: .normal)
        }
        
        if !post.content.isEmpty {
            self.writeView.memoTextView.text = post.content
            self.writeView.memoTextView.textColor = .black
            self.writeView.memoTextCountLabel.text = "\(post.content.count) / 100"
        }
    }
}
