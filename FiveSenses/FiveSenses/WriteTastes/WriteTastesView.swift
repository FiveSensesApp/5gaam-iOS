//
//  WriteTastesView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/14.
//

import UIKit

import RxSwift
import RxCocoa

final class WriteTastesView: UIView {
    var currentSense: FiveSenses?
    
    var backImageView = UIImageView()
    var selectedSenseImageView = UIImageView()
    var titleLabel = UILabel()
    var keywordTextField = CMTextField(isPlaceHolderBold: true, placeHolder: "취향키워드를 입력하세요. (최대 15자)", font: .bold(18.0), inset: UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0))
    var starView: WriteTastesStarView!
    var starInfoLabel = UILabel()
    var memoTextView = UITextView()
    var dateLabel = UILabel()
    var memoTextCountLabel = UILabel()
    
    private let textViewPlaceHolder = "함께 기억하고 싶은 이야기가 있다면 \n기록해주세요. (선택 / 최대 100자)"
    
    convenience init(sense: FiveSenses) {
        self.init()
        
        self.currentSense = sense
        self.starView = WriteTastesStarView(sense: sense)
        
        self.backgroundColor = .white
        
        self.addSubview(backImageView)
        self.backImageView.then {
            $0.image = UIImage(named: "뒤로가기_")
        }.snp.makeConstraints {
            $0.width.height.equalTo(38.0)
            $0.top.equalToSuperview().inset(25.0)
            $0.left.equalToSuperview().inset(21.0)
        }
        
        self.addSubview(selectedSenseImageView)
        self.selectedSenseImageView.then {
            $0.image = sense.image
        }.snp.makeConstraints {
            $0.width.height.equalTo(40.0)
            $0.top.equalTo(self.backImageView)
            $0.left.equalTo(self.backImageView.snp.right).offset(4.0)
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            var name = sense.name
            var footer = "으로 감각한\n오늘의 취향기록,"
            if sense == .dontKnow {
                name = "감각"
                footer = "이 정해지기 전인\n오늘의 취향 기록,"
            }
            let string = NSMutableAttributedString(string: name, attributes: [.font: UIFont.bold(26.0), .foregroundColor: sense.color])
            string.append(NSMutableAttributedString(string: footer, attributes: [.font: UIFont.bold(26.0), .foregroundColor: UIColor.black]))
            $0.attributedText = string
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }.snp.makeConstraints {
            $0.left.equalToSuperview().inset(35.0)
            $0.top.equalTo(self.selectedSenseImageView.snp.bottom).offset(20.0)
        }
        
        self.addSubview(keywordTextField)
        self.keywordTextField.then {
            $0.backgroundColor = .gray01
            $0.makeCornerRadius(radius: 10.0)
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(52.0)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(52.0)
        }
        
        self.addSubview(starView)
        self.starView.snp.makeConstraints {
            $0.width.equalTo(157.0)
            $0.height.equalTo(34.0)
            $0.top.equalTo(self.keywordTextField.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(starInfoLabel)
        self.starInfoLabel.then {
            $0.text = "취향을 얼마나 좋아하는지 표시해주세요!"
            $0.font = .regular(12.0)
            $0.textColor = sense.color
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.starView.snp.bottom)
            $0.height.equalTo(18.0)
        }
        
        self.addSubview(memoTextView)
        self.memoTextView.then {
            $0.contentInset = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 14.0, right: 14.0)
            $0.font = .medium(16.0)
            $0.makeCornerRadius(radius: 10.0)
            $0.backgroundColor = .gray01
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.spellCheckingType = .no
            $0.delegate = self
            $0.text = self.textViewPlaceHolder
            $0.textContainer.lineBreakMode = .byWordWrapping
            $0.textColor = .gray03
        }.snp.makeConstraints {
            $0.top.equalTo(self.starInfoLabel.snp.bottom).offset(20.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(150)
        }
        
        self.addSubview(dateLabel)
        self.dateLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray03
            $0.text = Date().toString(format: .WriteView)
        }.snp.makeConstraints {
            $0.top.equalTo(self.memoTextView.snp.bottom).offset(4.0)
            $0.height.equalTo(22.0)
            $0.left.equalToSuperview().inset(26.0)
        }
        
        self.addSubview(memoTextCountLabel)
        self.memoTextCountLabel.then {
            $0.font = .medium(14.0)
            $0.textColor = .gray03
            $0.text = "0 / 100"
        }.snp.makeConstraints {
            $0.top.equalTo(self.memoTextView.snp.bottom).offset(4.0)
            $0.height.equalTo(22.0)
            $0.right.equalToSuperview().inset(27.0)
        }
    }
}

extension WriteTastesView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .gray03
            self.updateCountLabel(characterCount: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 100 else { return false }
        self.updateCountLabel(characterCount: characterCount)
        
        return true
    }
    
    private func updateCountLabel(characterCount: Int) {
        self.memoTextCountLabel.text = "\(characterCount) / 100"
    }
}

final class WriteTastesStarView: UIStackView {
    var disposeBag = DisposeBag()
    var score: Int = 0
    
    var buttons: [UIButton] = []
    var sense: FiveSenses!
    
    convenience init(sense: FiveSenses) {
        self.init()
        self.sense = sense
        self.axis = .horizontal
        self.spacing = 7.0
        self.distribution = .fillEqually
        
        self.layoutMargins = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        self.isLayoutMarginsRelativeArrangement = true
        
        for i in 1..<6 {
            let button = UIButton()
            _ = button.then {
                $0.tag = i
                $0.setImage(sense.star(isEmpty: true), for: .normal)
                $0.addTarget(self, action: #selector(setScore), for: .touchUpInside)
            }
            self.buttons.append(button)
            self.addArrangedSubview(button)
        }
    }
    
    @objc func setScore(_ sender: UIButton) {
        self.score = sender.tag
        
        for button in buttons {
            button.setImage(self.sense.star(isEmpty: true), for: .normal)
        }
        
        for i in 0...(self.score - 1) {
            self.buttons[i].setImage(self.sense.star(isEmpty: false), for: .normal)
        }
    }
}
