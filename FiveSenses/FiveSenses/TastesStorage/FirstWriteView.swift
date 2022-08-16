//
//  FirstWriteView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/13.
//

import UIKit

final class FirstWriteView: UIView {
    var titleLabel = UILabel()
    
    var sightButton = WriteToSenseButtonView(image: UIImage(named: "원형) 시각"), title: "시각", color: .red03)
    var hearingButton = WriteToSenseButtonView(image: UIImage(named: "원형) 청각"), title: "청각", color: .blue03)
    var smellButton = WriteToSenseButtonView(image: UIImage(named: "원형) 후각"), title: "후각", color: .green03)
    var tasteButton = WriteToSenseButtonView(image: UIImage(named: "원형) 미각"), title: "미각", color: .yellow02)
    var touchButton = WriteToSenseButtonView(image: UIImage(named: "원형) 촉각"), title: "촉각", color: .purple03)
    var dontKnowButton = WriteToSenseButtonView(image: UIImage(named: "원형) 모르겠어요"), title: "모르겠어요", color: .gray04)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray01
        self.makeCornerRadius(radius: 10.0)
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            let string = NSMutableAttributedString(string: "님,\n처음으로 취향을 감각해보세요!", attributes: [.font: UIFont.bold(20.0), .foregroundColor: UIColor.black])
            $0.attributedText = string
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.left.right.equalToSuperview().inset(47.0)
        }
        
        let horizontalStackView1 = UIStackView(arrangedSubviews: [self.sightButton, self.hearingButton, self.smellButton]).then {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.distribution = .fillEqually
        }
        
        let horizontalStackView2 = UIStackView(arrangedSubviews: [self.tasteButton, self.touchButton, self.dontKnowButton]).then {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.distribution = .fillEqually
        }
        
        let stackView = UIStackView(arrangedSubviews: [horizontalStackView1, horizontalStackView2])
        
        self.addSubview(stackView)
        stackView.then {
            $0.axis = .vertical
            $0.spacing = 8.0
        }.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24.0)
            $0.left.right.equalToSuperview().inset(13.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WriteToSenseButtonView: UIView {
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    convenience init(image: UIImage?, title: String, color: UIColor) {
        self.init(frame: .zero)
        
        self.addSubview(imageView)
        self.imageView.then {
            $0.image = image
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(8.0)
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.text = title
            $0.font = .bold(16.0)
            $0.textColor = color
        }.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(7.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(14.0)
        }
    }
}
