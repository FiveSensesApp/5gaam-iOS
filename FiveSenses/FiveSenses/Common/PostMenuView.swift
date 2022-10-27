//
//  PostMenuView.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/26.
//

import UIKit

import RxSwift
import RxCocoa

class PostMenuView: UIView {
    class PostMenu: UIView {
        var imageView = UIImageView()
        var titleLabel = UILabel()
        
        convenience init(image: UIImage?, title: String) {
            self.init()
            self.backgroundColor = .black
            
            self.addSubview(imageView)
            self.imageView.then {
                $0.image = image
            }.snp.makeConstraints {
                $0.width.height.equalTo(28.0)
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().inset(11.0)
            }
            
            self.addSubview(titleLabel)
            self.titleLabel.then {
                $0.text = title
                $0.font = .bold(16.0)
                $0.textColor = .white
            }.snp.makeConstraints {
                $0.height.equalTo(29.0)
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(19.0)
            }
            
            self.snp.makeConstraints {
                $0.height.equalTo(44.0)
            }
        }
    }
    
    private var containerView = UIStackView()
    var modifyButton = PostMenu(image: UIImage(named: "수정 아이콘"), title: "수정")
    var shareButton = PostMenu(image: UIImage(named: "공유 아이콘"), title: "공유")
    var deleteButton = PostMenu(image: UIImage(named: "삭제 아이콘"), title: "삭제")
    
    var post: Post?
    lazy var deleteButtonTapped = self.deleteButton.rx.tapGesture().when(.recognized)
    lazy var modifyButtonTapped = self.modifyButton.rx.tapGesture().when(.recognized)
    lazy var shareButtonTapped = self.shareButton.rx.tapGesture().when(.recognized)
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        self.makeCornerRadius(radius: 10.0)
        
        self.addSubview(containerView)
        self.containerView.then {
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = 2.0
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.containerView.addArrangedSubview(modifyButton)
        let lineView1 = UIView().then {
            $0.backgroundColor = .gray04
        }
        self.containerView.addArrangedSubview(lineView1)
        lineView1.snp.makeConstraints {
            $0.height.equalTo(1.0)
        }
//        self.containerView.addArrangedSubview(shareButton)
//        let lineView2 = UIView().then {
//            $0.backgroundColor = .gray04
//        }
//        self.containerView.addArrangedSubview(lineView2)
//        lineView2.snp.makeConstraints {
//            $0.height.equalTo(1.0)
//        }
        self.containerView.addArrangedSubview(deleteButton)
        deleteButton.titleLabel.textColor = .red02
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
