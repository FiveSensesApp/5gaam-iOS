//
//  ShareContentPagerCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/02/18.
//

import Foundation

import FSPagerView
import RxSwift

final class ShareContentPagerCell: FSPagerViewCell {
    static let identifier = "ShareContentPagerCell"
    
    weak var contentTastesView: ContentTastesViewForShare?
    var backgroundShadowView = UIView()
    var backgroundImageView = UIImageView(image: UIImage(named: "모눈"))
    var capturedImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private var ratioLabel = UILabel()
    var addBackgroundImageButton = BaseButton()
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.shadowRadius = 0
        
        self.contentView.addSubview(self.backgroundShadowView)
        self.backgroundShadowView.then {
            $0.backgroundColor = .white
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.height.equalTo(288.0).priority(.high)
            $0.width.equalTo(162.0).priority(.high)
            $0.top.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(self.backgroundImageView)
        self.backgroundImageView.then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.height.equalTo(288.0).priority(.high)
            $0.width.equalTo(162.0).priority(.high)
            $0.top.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(self.capturedImageView)
        self.contentView.addSubview(self.ratioLabel)
        self.ratioLabel.do {
            $0.font = .bold(14.0)
            $0.textColor = .black
        }
        
        self.contentView.addSubview(self.addBackgroundImageButton)
        self.addBackgroundImageButton.then {
            $0.setImage(UIImage(named: "배경없음) 버튼"), for: .normal)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.width.height.equalTo(40.31)
            $0.bottom.equalTo(self.backgroundImageView).inset(13.5)
            $0.centerX.equalTo(self.backgroundImageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(contentTasteView: ContentTastesViewForShare, post: Post, ratio: SharePostRatioType) {
        self.contentTastesView = contentTasteView
        self.backgroundShadowView.isHidden = (ratio == .by11)
        self.backgroundImageView.isHidden = (ratio == .by11)
        self.addBackgroundImageButton.isHidden = (ratio == .by11)
        
        switch ratio {
        case .by11:
            self.capturedImageView.addShadow(offset: CGSize(width: 0, height: 0))
            self.capturedImageView.snp.remakeConstraints {
                $0.width.height.equalTo(220.0)
                $0.center.equalToSuperview()
            }
            self.ratioLabel.then {
                $0.text = "1:1"
            }.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.capturedImageView.snp.bottom).offset(15.0)
            }
        case .by169:
            self.capturedImageView.layer.shadowRadius = 0
            self.backgroundShadowView.addShadow(offset: CGSize(width: 0, height: 0))
            self.capturedImageView.snp.remakeConstraints {
                $0.width.height.equalTo(119.73)
                $0.center.equalTo(self.backgroundImageView)
            }
            self.ratioLabel.then {
                $0.text = "16:9"
            }.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.backgroundImageView.snp.bottom).offset(15.0)
            }
        }
        
        self.capturedImageView.image = self.renderTastesViewAsImage()
    }
    
    private func renderTastesViewAsImage() -> UIImage? {
        
        if self.contentTastesView?.contentTextView.isHidden == true {
            self.contentTastesView?.frame = CGRect(x: 0, y: 0, width: 220, height: 124.12)
        } else {
            self.contentTastesView?.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        }
        
        self.contentTastesView?.layoutIfNeeded()
        
        return self.contentTastesView?.asImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
}
