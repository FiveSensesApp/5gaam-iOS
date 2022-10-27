//
//  MonthlySenseView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/17.
//

import UIKit

final class MonthlySenseView: UIView {
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    private var thisMonthSenseImageView = UIImageView()
    private var thisMonthSenseNameLabel = UILabel()
    var thisMonthSenseCountLabel = UILabel()
    private var monthCardStackView = UIStackView()
    private var month1CardView = MonthlyCardView()
    private var month2CardView = MonthlyCardView()
    private var month3CardView = MonthlyCardView()
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    private lazy var monthCardArray = [month1CardView, month2CardView, month3CardView]
    
    var emptyImageView = UIImageView()
    
    var currentMonths: [MonthlyCategory?] = [] {
        didSet {
            guard currentMonths.count == 3 else { return }
            
            currentMonths.enumerated().forEach { (index, value) in
                if value == nil {
                    self.monthCardArray[index].setEmpty()
                } else {
                    self.monthCardArray[index].senseImageView.image = UIImage(named: "box icon-\(value!.category.name)")
                    if value!.category == .dontKnow {
                        self.monthCardArray[index].senseImageView.image = UIImage(named: "box icon-Empty")
                    }
                    self.monthCardArray[index].monthLabel.text = value!.month.toString(format: .OnlyMonth)
                }
            }
        }
    }
    
    var sense: FiveSenses? {
        didSet {
            if let sense = sense {
                self.thisMonthSenseImageView.image = sense.monthlyCharacterImage
                self.thisMonthSenseNameLabel.text = "\(sense.name) | "
                self.thisMonthSenseNameLabel.textColor = sense.color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(18.0)
            $0.textColor = .black
            $0.text = "이 달의 감각"
        }.snp.makeConstraints {
            $0.top.equalTo(20.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22.0)
        }
        
        self.addSubview(subTitleLabel)
        self.subTitleLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray04
            $0.text = "월 별로 가장 많이 기록한 감각을 볼 수 있어요."
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            $0.height.equalTo(14.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(thisMonthSenseImageView)
        self.thisMonthSenseImageView.then {
            $0.image = FiveSenses.hearing.monthlyCharacterImage
        }.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(15.0)
            $0.left.right.equalToSuperview().inset(44.5)
            $0.height.equalTo(self.thisMonthSenseImageView.snp.width).multipliedBy(134.0 / 246.0)
        }
        
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.then {
            $0.axis = .horizontal
            $0.spacing = 0
        }.snp.makeConstraints {
            $0.top.equalTo(self.thisMonthSenseImageView.snp.bottom).offset(5.0)
            $0.height.equalTo(17.0)
            $0.centerX.equalToSuperview()
        }
        
        stackView.addArrangedSubview(thisMonthSenseNameLabel)
        _ = self.thisMonthSenseNameLabel.then {
            $0.font = .bold(14.0)
        }
        
        stackView.addArrangedSubview(thisMonthSenseCountLabel)
        _ = self.thisMonthSenseCountLabel.then {
            $0.font = .bold(14.0)
            $0.textColor = .gray04
        }
        
        let lineView = UIView()
        self.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.left.right.equalToSuperview().inset(14.5)
            $0.top.equalTo(stackView.snp.bottom).offset(10.0)
        }
        
        self.addSubview(monthCardStackView)
        self.monthCardStackView.then {
            $0.axis = .horizontal
            $0.spacing = 14.0
        }.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(98.0)
        }
        
        self.monthCardArray.forEach {
            self.monthCardStackView.addArrangedSubview($0)
        }
        
        self.addSubview(leftButton)
        self.leftButton.then {
            $0.setImage(UIImage(named: "좌측 넘기기"), for: .normal)
            $0.imageView?.tintColor = .gray04
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.right.equalTo(self.monthCardStackView.snp.left).offset(-5.0)
            $0.top.equalTo(lineView.snp.bottom).offset(36.0)
        }
        
        self.addSubview(rightButton)
        self.rightButton.then {
            $0.setImage(UIImage(named: "우측 넘기기"), for: .normal)
            $0.imageView?.tintColor = .gray04
        }.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.left.equalTo(self.monthCardStackView.snp.right).offset(5.0)
            $0.top.equalTo(lineView.snp.bottom).offset(36.0)
        }
        
        self.addSubview(emptyImageView)
        self.emptyImageView.then {
            $0.image = UIImage(named: "Empty이 달의 감각")
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MonthlyCardView: UIView {
    var senseImageView = UIImageView()
    var monthLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.snp.makeConstraints {
            $0.width.equalTo(63.0)
        }
        
        self.addSubview(senseImageView)
        self.senseImageView.then {
            $0.image = UIImage(named: "box icon-Empty")
        }.snp.makeConstraints {
            $0.width.equalTo(63.0)
            $0.height.equalTo(76.0)
            $0.top.left.right.equalToSuperview()
        }
        
        self.addSubview(monthLabel)
        self.monthLabel.then {
            $0.font = .bold(14.0)
            $0.textColor = .gray04
            $0.text = "-"
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(self.senseImageView.snp.bottom).offset(5.0)
            $0.height.equalTo(17.0)
            $0.left.right.equalToSuperview()
        }
    }
    
    func setEmpty() {
        self.senseImageView.image = UIImage(named: "box icon-Empty")
        self.monthLabel.text = "-"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
