//
//  PostDistributionView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/10/16.
//

import UIKit

final class PostDistributionView: UIView {
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var distributionGraphView = DistributionGraphView()
    var postCountStackView = UIStackView()
    var emptyImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.makeCornerRadius(radius: 12.0)
        
        self.addSubview(titleLabel)
        self.titleLabel.then {
            $0.font = .bold(18.0)
            $0.textColor = .black
            $0.text = "감각별 분포도"
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(22.0)
        }
        
        self.addSubview(subtitleLabel)
        self.subtitleLabel.then {
            $0.font = .medium(12.0)
            $0.textColor = .gray04
            $0.text = "각 감각별 갯수와 비율을 알 수 있어요."
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(14.0)
        }
        
        self.addSubview(distributionGraphView)
        self.distributionGraphView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(46.0)
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(15.0)
        }
        
        let lineView = UIView()
        self.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray01
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.left.right.equalToSuperview().inset(14.0)
            $0.top.equalTo(distributionGraphView.snp.bottom).offset(12.0)
        }
        
        self.addSubview(postCountStackView)
        self.postCountStackView.then {
            $0.axis = .horizontal
            $0.spacing = 16.0
            $0.distribution = .fillEqually
        }.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(15.0)
            $0.left.right.equalToSuperview().inset(23.5)
            $0.height.equalTo(37.0)
        }
        
        self.addSubview(emptyImageView)
        emptyImageView.then {
            $0.image = UIImage(named: "Empty감각별 분포도")
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setPostCount(values: [(sense: FiveSenses, count: Int)]) {
        for view in self.postCountStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for value in values {
            guard value.count != 0 else {
               return
            }
            
            let countView = PostCountView(value: value)
            self.postCountStackView.addArrangedSubview(countView)
            countView.value = value
            countView.snp.makeConstraints {
                $0.height.equalTo(37.0)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PostCountView: UIView {
    private var countLabel = UILabel()
    private var senseImageView = UIImageView()
    private var senseNameLabel = UILabel()
    
    var value: (sense: FiveSenses, count: Int)? {
        didSet {
            if let value = self.value {
                self.countLabel.text = "\(value.count)"
                self.senseImageView.image = value.sense.image
                self.senseNameLabel.textColor = value.sense.color
                self.senseNameLabel.text = value.sense.name
                if value.sense == .dontKnow {
                    self.senseNameLabel.text = "기타"
                }
            }
        }
    }
    
    convenience init(value: (sense: FiveSenses, count: Int)) {
        self.init()
        
        self.addSubview(countLabel)
        self.countLabel.then {
            $0.font = .bold(14.0)
            $0.textColor = .black
            $0.textAlignment = .center
        }.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(17.0)
        }
        
        self.addSubview(senseImageView)
        self.senseImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(self.countLabel.snp.bottom).offset(5.0)
            $0.width.height.equalTo(12.0)
        }
        
        self.addSubview(senseNameLabel)
        self.senseNameLabel.then {
            $0.font = .medium(12.0)
        }.snp.makeConstraints {
            $0.centerY.equalTo(self.senseImageView)
            $0.left.equalTo(self.senseImageView.snp.right).offset(1.0)
            $0.right.equalToSuperview()
        }
    }
}

final class DistributionGraphView: UIView {
    private var element1ImageView = UIImageView()
    private var element2ImageView = UIImageView()
    private var element3ImageView = UIImageView()
    private var element4ImageView = UIImageView()
    private var element5ImageView = UIImageView()
    private var element6ImageView = UIImageView()
    
    lazy private var imageViewArray = [element1ImageView, element2ImageView, element3ImageView, element4ImageView, element5ImageView, element6ImageView]
    
    private var element1Label = UILabel()
    private var element2Label = UILabel()
    private var element3Label = UILabel()
    private var element4Label = UILabel()
    private var element5Label = UILabel()
    private var element6Label = UILabel()
    
    lazy private var labelArray = [element1Label, element2Label, element3Label, element4Label, element5Label, element6Label]
    
    private let graphContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(graphContainerView)
        self.graphContainerView.then {
            $0.makeCornerRadius(radius: 15.0)
        }.snp.makeConstraints {
            $0.height.equalTo(30.0)
            $0.left.right.equalToSuperview().inset(15.0)
            $0.top.equalToSuperview()
        }
        
        self.graphContainerView.addSubview(element1ImageView)
        self.element1ImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.lessThanOrEqualTo(0)
            $0.height.equalTo(30.0)
        }
        self.addSubview(element1Label)
        self.element1Label.then {
            $0.font = .regular(10.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.graphContainerView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(self.element1ImageView)
        }
        
        self.graphContainerView.addSubview(element2ImageView)
        self.element2ImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(self.element1ImageView.snp.right)
            $0.width.lessThanOrEqualTo(0)
            $0.height.equalTo(30.0)
        }
        self.addSubview(element2Label)
        self.element2Label.then {
            $0.font = .regular(10.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.graphContainerView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(self.element2ImageView)
        }
        
        self.graphContainerView.addSubview(element3ImageView)
        self.element3ImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(self.element2ImageView.snp.right)
            $0.width.lessThanOrEqualTo(0)
            $0.height.equalTo(30.0)
        }
        self.addSubview(element3Label)
        self.element3Label.then {
            $0.font = .regular(10.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.graphContainerView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(self.element3ImageView)
        }
        
        self.graphContainerView.addSubview(element4ImageView)
        self.element4ImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(self.element3ImageView.snp.right)
            $0.width.lessThanOrEqualTo(0)
            $0.height.equalTo(30.0)
        }
        self.addSubview(element4Label)
        self.element4Label.then {
            $0.font = .regular(10.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.graphContainerView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(self.element4ImageView)
        }
        
        self.graphContainerView.addSubview(element5ImageView)
        self.element5ImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(self.element4ImageView.snp.right)
            $0.width.lessThanOrEqualTo(0)
            $0.height.equalTo(30.0)
        }
        self.addSubview(element5Label)
        self.element5Label.then {
            $0.font = .regular(10.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.graphContainerView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(self.element5ImageView)
        }
        
        self.graphContainerView.addSubview(element6ImageView)
        self.element6ImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(self.element5ImageView.snp.right)
            $0.width.lessThanOrEqualTo(0)
            $0.height.equalTo(30.0)
            $0.right.equalTo(graphContainerView).priority(.high)
        }
        self.addSubview(element6Label)
        self.element6Label.then {
            $0.font = .regular(10.0)
        }.snp.makeConstraints {
            $0.top.equalTo(self.graphContainerView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(self.element6ImageView)
        }
    }
    
    func setGraph(values: [(sense: FiveSenses, count: Int)]) {
        let totalCount: Double = values.map { Double($0.count) }.reduce(0, +)
        
        for (index, value) in values.enumerated() {
            var graphImage: UIImage?
            
            switch value.sense {
            case .sight:
                graphImage = UIImage(named: "감각 분포 막대 그래프-시각")
            case .smell:
                graphImage = UIImage(named: "감각 분포 막대 그래프-후각")
            case .hearing:
                graphImage = UIImage(named: "감각 분포 막대 그래프-청각")
            case .taste:
                graphImage = UIImage(named: "감각 분포 막대 그래프-미각")
            case .touch:
                graphImage = UIImage(named: "감각 분포 막대 그래프-촉각")
            case .dontKnow:
                graphImage = UIImage(named: "감각 분포 막대 그래프-모르겠어요")
            }
            
            let ratio = Double(value.count) / totalCount
            self.imageViewArray[index].image = graphImage
            self.labelArray[index].textColor = value.sense.color
            self.labelArray[index].text = "\(Int(ratio * 100.0))%"
            self.imageViewArray[index].snp.updateConstraints {
                let width = (Constants.DeviceWidth - 70.0) * ratio
                $0.width.lessThanOrEqualTo(width)
            }
            if value.count == 0 {
                self.labelArray[index].text = ""
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
