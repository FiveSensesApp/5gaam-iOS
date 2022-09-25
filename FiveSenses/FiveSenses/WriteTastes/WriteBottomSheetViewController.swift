//
//  WriteBottomSheetViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

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
    var writebuttonView = UIView()
    var emptyAlertLabel = UILabel()
    
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
        vc.isBackgroundDismissOn = false
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
        
        NotificationCenter.default.post(name: .didWriteViewDismiss, object: nil)
        
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
        
        if let writeButton = writeButton {
            self.view.addSubview(writebuttonView)
            writebuttonView.frame = writeButton.frame
            writebuttonView.backgroundColor = .clear
        }
        
        switch self.currentType {
        case .category:
            self.setCategoryView()
        case .write:
            self.setWriteView()
        }
        
        self.emptyAlertLabel.isHidden = true
        self.emptyAlertLabel.textAlignment = .center
        self.emptyAlertLabel.font = .semiBold(16.0)
        self.emptyAlertLabel.textColor = .black
        self.emptyAlertLabel.text = "키워드와 별점은 필수입니다!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCategoryButtons()
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive { [weak self] height in
                guard let self = self, let tabBar = self.tabBar else { return }
                
                if height == 0 {
                    self.writeView.titleLabel.snp.remakeConstraints {
                        $0.left.equalToSuperview().inset(35.0)
                        $0.top.equalTo(self.writeView.selectedSenseImageView.snp.bottom).offset(20.0)
                    }
                    self.writeView.layoutSubviews()
                    self.containerView.snp.remakeConstraints {
                        $0.bottom.equalTo(tabBar.snp.top).offset(-1.0)
                        $0.left.right.equalToSuperview()
                    }
                } else {
                    self.writeView.titleLabel.snp.remakeConstraints {
                        $0.height.equalTo(0)
                        $0.top.equalTo(self.writeView.selectedSenseImageView.snp.bottom).offset(-27.0)
                    }
                    self.writeView.layoutSubviews()
                    self.containerView.snp.remakeConstraints {
                        $0.top.equalToSuperview().inset(44.0)
                        $0.left.right.equalToSuperview()
                    }
                }
                
                UIView.animate(withDuration: 0) {
                    self.writeView.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
        
        self.writebuttonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.writeButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != containerView && self.isBackgroundDismissOn {
            self.dismissActionSheet()
        } else if !(touch?.view is UITextField) {
            self.view.endEditing(true)
        }
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
        self.emptyAlertLabel.removeFromSuperview()
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
                guard let self = self else { return }
                self.showReSelectAlert()
            }
            .disposed(by: disposeBag)
        self.writeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.contentView.addSubview(self.emptyAlertLabel)
        self.emptyAlertLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30.0)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func showReSelectAlert() {
        self.view.endEditing(true)
        
        let alert = CategoryReselectAlert(title: "다시 선택하시겠습니까?", content: "작성한 글은 저장되지 않아요.", okButtonTitle: "뒤로가기", cancelButtonTitle: "계속쓰기")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        alert.okButton.rx.tap
            .bind { [weak self] in
                self?.setCategoryView()
            }.disposed(by: disposeBag)
        alert.cancelButton.rx.tap
            .bind {
                alert.dismiss(animated: true)
            }.disposed(by: disposeBag)
        self.present(alert, animated: true)
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
    
    private func writeButtonTapped() {
        switch self.currentType {
        case .category:
            self.dismissActionSheet()
        case .write:
            self.writePost()
        }
    }
    
    private func writePost() {
        guard !self.writeView.keywordTextField.text.isNilOrEmpty && self.writeView.starView.score != 0 else {
            self.emptyAlertLabel.isHidden = false
            return
        }
        
        PostServices.createPost(creatingPost: CreatingPost(
            category: self.writeView.currentSense ?? .dontKnow,
            keyword: self.writeView.keywordTextField.text ?? "",
            star: self.writeView.starView.score,
            content: self.getContentText()
        )).subscribe(onNext: { [weak self]  in
            if $0 != nil {
                self?.showWriteFinishAlert()
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func getContentText() -> String {
        if self.writeView.memoTextView.text == "함께 기억하고 싶은 이야기가 있다면 \n기록해주세요. (선택 / 최대 100자)" {
            return ""
        } else {
            return self.writeView.memoTextView.text ?? ""
        }
    }
    
    private func showWriteFinishAlert() {
        let alert = CategoryReselectAlert(title: "기록 완료", content: "취향 입력이 완료되었어요.", okButtonTitle: "보관함 가기", cancelButtonTitle: "계속쓰기")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        alert.isBackgroundDismissOn = false
        
        alert.cancelButton.rx.tap
            .bind { [weak self] in
                alert.dismiss(animated: true)
                self?.setCategoryView()
            }.disposed(by: disposeBag)
        alert.okButton.rx.tap
            .bind { [weak self] in
                alert.dismiss(animated: true)
                self?.dismissActionSheet()
            }.disposed(by: disposeBag)
        self.present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

class CategoryReselectAlert: TwoButtonAlertController {
    var backgroundView = UIView()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .clear
        
        self.view.insertSubview(self.backgroundView, belowSubview: self.contentView)
        self.backgroundView.then {
            $0.backgroundColor = .white.withAlphaComponent(0.9)
        }.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(153.0)
            $0.left.right.equalToSuperview().inset(10.0)
            $0.height.equalTo(340.0)
        }
        
        self.contentView.snp.remakeConstraints {
            $0.left.right.equalToSuperview().inset(32.0)
            $0.top.equalTo(self.backgroundView).inset(71.0)
        }
    }
    
    class func showAlert(
        viewController: UIViewController,
        title: String,
        content: String,
        buttonTitle: String,
        cancelButtonTitle: String,
        okAction: () -> Void,
        cancelAction: () -> Void
    ) {
        let vc = CategoryReselectAlert(title: title, content: content, okButtonTitle: buttonTitle, cancelButtonTitle: cancelButtonTitle)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true)
    }
}
