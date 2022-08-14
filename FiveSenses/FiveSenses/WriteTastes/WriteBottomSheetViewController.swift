//
//  WriteBottomSheetViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/13.
//

import UIKit

import RxSwift
import RxCocoa

enum WriteBottomSheetType {
    case category
    case write
}

final class WriteBottomSheetViewController: BaseBottomSheetController {
    var writeCategorySelectView = WriteCategorySelectView()
    var writeView = WriteTastesView()
    var backgroundView = UIView()
    
    let maskView = UIView(frame: CGRect(x: 0, y: 0, width: 69.0, height: 69.0)).then {
        $0.makeCornerRadius(radius: 69 / 2.0)
    }
    
    var currentType: WriteBottomSheetType = .category {
        didSet {
            guard let writeButton = self.writeButton else { return }
            switch self.currentType {
            case .category:
                writeButton.setImage(UIImage(named: "기록 닫기 버튼"), for: .normal)
            case .write:
                writeButton.setImage(UIImage(named: "기록 완료 버튼"), for: .normal)
            }
        }
    }
    
    weak var tabBar: UITabBar?
    weak var writeButton: UIButton?
    
    convenience init(type: WriteBottomSheetType, tabBar: UITabBar, writeButton: UIButton) {
        self.init()
        
        self.writeButton = writeButton
        self.currentType = type
        self.tabBar = tabBar
        for item in self.tabBar?.items ?? [] {
            item.image = nil
            item.isEnabled = false
        }
    }
    
    class func showBottomSheet(viewController: UIViewController, type: WriteBottomSheetType, tabBar: UITabBar, writeButton: UIButton) {
        let vc = WriteBottomSheetViewController(type: type, tabBar: tabBar, writeButton: writeButton)
        vc.modalPresentationStyle = .overCurrentContext
        viewController.present(vc, animated: false)
        switch type {
        case .category:
            writeButton.setImage(UIImage(named: "기록 닫기 버튼"), for: .normal)
        case .write:
            writeButton.setImage(UIImage(named: "기록 완료 버튼"), for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.mask()
        if !isUp, let tabBar = self.tabBar {
            isUp = true
            
            self.contentView.snp.remakeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(593.0)
            }
            
            self.containerView.snp.remakeConstraints {
                $0.bottom.equalTo(tabBar.snp.top).offset(-1.0)
                $0.left.right.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    override func dismissActionSheet() {
        super.dismissActionSheet()
        
        self.writeButton?.setImage(UIImage(named: "기록 시작 버튼"), for: .normal)
        for (index, item) in (self.tabBar?.items ?? []).enumerated() {
            item.isEnabled = true
            item.image = [UIImage(named: "보관함 아이콘"), nil, UIImage(named: "성향분석 아이콘")][index]
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .clear
        view.isOpaque = false
        
        self.cancelButton.isHidden = true
        self.titleLabel.isHidden = true
        
        self.view.insertSubview(backgroundView, at: 0)
        self.backgroundView.then {
            $0.backgroundColor = .gray.withAlphaComponent(0.25)
        }.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(97.0)
        }
        
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.contentView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        switch self.currentType {
        case .category:
            self.setCategoryView()
        case .write:
            self.setWriteView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCategoryButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchView = touches.first?.view else { return }
        
        if (
            !self.contentView.subviews.contains(touchView) &&
            !self.writeView.subviews.contains(touchView) &&
            !self.writeCategorySelectView.contains(touchView)
        ) && self.isBackgroundDismissOn {
            self.dismissActionSheet()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setCategoryButtons() {
        Observable.merge(
            self.writeCategorySelectView.sightButton.rx.tapGesture().when(.recognized).map { _ in return FiveSenses.sight },
            self.writeCategorySelectView.hearingButton.rx.tapGesture().when(.recognized).map { _ in return FiveSenses.hearing },
            self.writeCategorySelectView.smellButton.rx.tapGesture().when(.recognized).map { _ in return FiveSenses.smell },
            self.writeCategorySelectView.tasteButton.rx.tapGesture().when(.recognized).map { _ in return FiveSenses.taste },
            self.writeCategorySelectView.touchButton.rx.tapGesture().when(.recognized).map { _ in return FiveSenses.touch },
            self.writeCategorySelectView.dontKnowButton.rx.tapGesture().when(.recognized).map { _ in return FiveSenses.dontKnow }
        ).bind { [weak self] in
            guard let self = self else { return }
            self.writeView = WriteTastesView(sense: $0)
            self.setWriteView()
        }
        .disposed(by: disposeBag)
    }
    
    func setCategoryView() {
        self.writeView.removeFromSuperview()
        self.currentType = .category
        self.contentView.addSubview(self.writeCategorySelectView)
        self.writeCategorySelectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.writeCategorySelectView.dateLabel.text = Date().toString(format: .CategoryHeader) ?? ""
    }
    
    func setWriteView() {
        self.writeCategorySelectView.removeFromSuperview()
        self.currentType = .write
        self.contentView.addSubview(self.writeView)
        self.writeView.backImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.setCategoryView()
            }
            .disposed(by: disposeBag)
        self.writeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func mask() {
        let layer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect: CGRect(x: Constants.DeviceWidth / 2.0 - (69.0 / 2.0), y: 594.0 - 15.0, width: 69.0, height: 69.0), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 69.0 / 2.0, height: 69.0 / 2.0))
        path.append(UIBezierPath(rect: CGRect(x: 0, y: 0, width: Constants.DeviceWidth, height: 594.0)))
        layer.path = path.cgPath
        layer.fillRule = .evenOdd
        layer.isOpaque = false
        layer.backgroundColor = UIColor.clear.cgColor
        self.contentView.layer.mask = layer
        
        let cornerPath = self.containerView.getRoundCornerPath(corners: [.topLeft, .topRight], radius: 30.0)
        path.append(cornerPath)
        path.append(UIBezierPath(rect: CGRect(x: 0, y: 0, width: Constants.DeviceWidth, height: 594.0)))
        layer.path = path.cgPath
        self.containerView.layer.mask = layer
    }
}
