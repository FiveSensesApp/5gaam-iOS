//
//  SearchPostViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2023/01/27.
//

import UIKit

import RxSwift
import RxCocoa
import SwiftyUserDefaults
import RxKeyboard

final class SearchPostViewController: CMViewController {
    private var searchTextField = CMTextField(isPlaceHolderBold: true, placeHolder: "검색어를 입력해 주세요.", font: .semiBold(16.0), inset: UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 0))
    private var searchCancelButton = BaseButton()
    
    private lazy var recentSearchTextsHeaderView = RecentSearchTextsHeaderView()
    private var recentSearchTextsDiffableDataSource: UICollectionViewDiffableDataSource<Int, RecentSearchTextIdentifier>!
    private var recentSearchTextsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var isSearching = false
    
    private var searchResultLabel = UILabel()
    private var searchResultCountLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0))
    private var searchResultDiffableDataSource: UICollectionViewDiffableDataSource<Int, Post>!
    private var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var searchResultEmptyImageView = UIImageView(image: UIImage(named: "EmptySearchResult"))
    
    private var isPostMenuOpen = false
    private var postMenuView = PostMenuView()
    
    private lazy var viewModel = SearchPostViewModel(
        input: SearchPostViewModel.Input(
            deleteAllButtonTapped: self.recentSearchTextsHeaderView.deleteAllButton.rx.tap
        )
    )
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        let searchIconView = UIImageView(image: UIImage(named: "검색 닫혔을때"))
        self.navigationBarView.addSubview(searchIconView)
        searchIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(44.0)
        }
        
        let lineView = UIView()
        self.navigationBarView.addSubview(lineView)
        lineView.then {
            $0.backgroundColor = .gray03
            $0.makeCornerRadius(radius: 0.5)
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview().inset(54.0)
            $0.right.equalToSuperview().inset(22.0)
            $0.left.equalTo(searchIconView.snp.right).offset(2.0)
        }
        
        self.navigationBarView.addSubview(searchCancelButton)
        self.searchCancelButton.then {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.gray04, for: .normal)
            $0.titleLabel?.font = .semiBold(16.0)
        }.snp.makeConstraints {
            $0.width.equalTo(44.0)
            $0.height.equalTo(16.0)
            $0.right.equalToSuperview().inset(22.0)
            $0.bottom.equalTo(lineView.snp.top).offset(-6.0)
        }
        
        self.navigationBarView.addSubview(self.searchTextField)
        self.searchTextField.then {
            $0.returnKeyType = .search
            $0.clearButtonMode = .whileEditing
        }.snp.makeConstraints {
            $0.left.equalTo(lineView)
            $0.bottom.equalTo(lineView.snp.top).offset(-6.0)
            $0.height.equalTo(16.0)
            $0.right.equalTo(searchCancelButton.snp.left)
        }
        
        self.navigationBarView.addSubview(recentSearchTextsHeaderView)
        self.recentSearchTextsHeaderView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(44.0)
        }
        
        self.navigationBarView.addSubview(searchResultLabel)
        self.searchResultLabel.then {
            $0.text = "검색 결과"
            $0.textColor = .black
            $0.font = .bold(26.0)
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(7.0)
            $0.left.equalToSuperview().inset(20.44)
        }
        
        self.contentView.addSubview(searchResultCountLabel)
        self.searchResultCountLabel.then {
            $0.makeCornerRadius(radius: 18.0)
            $0.backgroundColor = .gray01
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom).offset(12.0)
            $0.height.equalTo(36.0)
            $0.left.right.equalToSuperview().inset(21.0)
        }
        
        self.contentView.addSubview(self.searchResultCollectionView)
        self.searchResultCollectionView.then {
            $0.register(ContentTastesCell.self, forCellWithReuseIdentifier: ContentTastesCell.identifier)
            $0.backgroundColor = .white
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                $0.minimumLineSpacing = 16.0
                $0.minimumInteritemSpacing = 16.0
            }
            $0.allowsSelection = true
            $0.keyboardDismissMode = .onDrag
        }.snp.makeConstraints {
            $0.top.equalTo(searchResultCountLabel.snp.bottom).offset(32.0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.contentView.addSubview(self.recentSearchTextsCollectionView)
        self.recentSearchTextsCollectionView.then {
            $0.register(RecentSearchTextCell.self, forCellWithReuseIdentifier: RecentSearchTextCell.identifier)
            $0.backgroundColor = .white
            $0.contentInset = UIEdgeInsets(top: 12.0, left: 0, bottom: 0, right: 0)
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                $0.itemSize = CGSize(width: Constants.DeviceWidth, height: 50.0)
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
            }
            $0.allowsSelection = false
            $0.keyboardDismissMode = .interactive
            $0.isScrollEnabled = true
            $0.bounces = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.contentView.addSubview(searchResultEmptyImageView)
        self.searchResultEmptyImageView.then {
            $0.isHidden = true
        }.snp.makeConstraints {
            $0.top.equalTo(self.searchResultCountLabel.snp.bottom).offset(105.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.height.equalTo(self.searchResultEmptyImageView.snp.width)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.rx.controlEvent([.editingDidEndOnExit])
            .map { [weak self] _ -> String in
                guard let self else { return "" }
                return self.searchTextField.text ?? ""
            }
            .bind(to: self.viewModel.input!.searchText)
            .disposed(by: self.disposeBag)
        
        self.recentSearchTextsDiffableDataSource = UICollectionViewDiffableDataSource<Int, RecentSearchTextIdentifier>(collectionView: self.recentSearchTextsCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchTextCell.identifier, for: indexPath) as! RecentSearchTextCell
            cell.textLabel.text = itemIdentifier.text
            cell.textLabel.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self else { return }
                    
                    self.searchTextField.text = itemIdentifier.text
                    self.viewModel.input!.searchText.accept(itemIdentifier.text)
                }
                .disposed(by: cell.disposeBag)
            cell.deleteButton
                .rx.tap
                .bind { [weak self] _ in
                    guard let self else { return }
                    
                    self.deleteSearchText(text: itemIdentifier.text)
                }
                .disposed(by: cell.disposeBag)
            return cell
        }
        
        self.recentSearchTextsCollectionView.dataSource = self.recentSearchTextsDiffableDataSource
        
        self.viewModel.output!.recentSearchTexts
            .map {
                $0.enumerated().map {
                    RecentSearchTextIdentifier(text: $1, id: $0)
                }
            }
            .bind { [weak self] in
                guard let self else { return }
                
                var snapShot = NSDiffableDataSourceSnapshot<Int, RecentSearchTextIdentifier>()
                snapShot.appendSections([0])
                snapShot.appendItems($0)
                
                self.recentSearchTextsDiffableDataSource.apply(snapShot)
            }
            .disposed(by: self.disposeBag)
        
        self.searchResultDiffableDataSource = UICollectionViewDiffableDataSource<Int, Post>(collectionView: self.searchResultCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentTastesCell.identifier, for: indexPath) as! ContentTastesCell
            cell.configure(tastePost: itemIdentifier)
            cell.tastesView.menuButton
                .rx.tapGesture()
                .when(.recognized)
                .bind { [weak self, weak cell] _ in
                    guard let self, let cell else { return }
                    self.showPostMenu(menuButtonFrame: cell.frame, post: itemIdentifier)
                }
                .disposed(by: cell.disposeBag)
            return cell
        }
        
        self.searchResultCollectionView.dataSource = self.searchResultDiffableDataSource
        self.searchResultCollectionView.delegate = self
        
        self.viewModel.output!.searchResults
            .bind { [weak self] in
                guard let self else { return }
                
                var snapShot = NSDiffableDataSourceSnapshot<Int, Post>()
                snapShot.appendSections([0])
                snapShot.appendItems($0)
                
                self.searchResultDiffableDataSource.apply(snapShot)
                
                self.searchResultEmptyImageView.isHidden = !($0.isEmpty && !self.searchTextField.text.isNilOrEmpty)
                self.hiddenRecentViews(hidden: !self.searchTextField.text.isNilOrEmpty)
                
                if !self.searchTextField.text.isNilOrEmpty {
                    self.saveSearchText(text: self.searchTextField.text!)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output!.searchResults
            .bind { [weak self] in
                guard let self else { return }
                
                let string = NSMutableAttributedString()
                string.append(NSAttributedString(string: "총 ", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray04]))
                string.append(NSAttributedString(string: "\($0.count)개의 결과", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.black]))
                string.append(NSAttributedString(string: "가 존재합니다.", attributes: [.font: UIFont.bold(16.0), .foregroundColor: UIColor.gray04]))
                self.searchResultCountLabel.attributedText = string
            }
            .disposed(by: self.disposeBag)
        
        self.searchTextField.rx.text
            .bind { [weak self] in
                guard let self else { return }
                
                if $0.isNilOrEmpty {
                    self.hiddenRecentViews(hidden: false)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.searchCancelButton
            .rx.tap
            .bind { [weak self] in
                guard let self else { return }
                
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance
            .visibleHeight
            .drive { [weak self] in
                if $0 > 0 {
                    self?.dismissPostMenu()
                }
            }
            .disposed(by: self.disposeBag)
        
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
                let post = self.postMenuView.post
                
                let vc = ModifyPostViewController()
                vc.currentPost = post
                vc.modalPresentationStyle = .fullScreen
                vc.dismissCompletion = { newPost in
                    guard let index = self.viewModel.output?.searchResults.value.firstIndex(where: {
                        post?.id == $0.id
                    }) else {
                        return
                    }
                    var array = self.viewModel.output!.searchResults.value
                    array[index] = newPost
                    self.viewModel.output?.searchResults.accept(array)
                }
                self.present(vc, animated: true)
                self.dismissPostMenu()
            }
            .disposed(by: disposeBag)
        
        self.postMenuView.shareButtonTapped
            .asObservable()
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                let prepareShareViewController = PrepareShareViewController()
                prepareShareViewController.tastePost = self.postMenuView.post
                let navigationController = CMNavigationController(rootViewController: prepareShareViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
                
            }
            .disposed(by: disposeBag)
    }
    
    private func hiddenRecentViews(hidden: Bool) {
        self.recentSearchTextsCollectionView.isHidden = hidden
        self.recentSearchTextsHeaderView.isHidden = hidden
        
        if hidden == false {
            self.searchResultEmptyImageView.isHidden = true
            self.dismissPostMenu()
        }
        
        self.searchResultLabel.isHidden = !hidden
        self.searchResultCountLabel.isHidden = !hidden
        self.searchResultCollectionView.isHidden = !hidden
    }
    
    private func saveSearchText(text: String) {
        var current = Defaults[\.recentSearchTexts]
        
        if let first = current.firstIndex(of: text) {
            current.remove(at: first)
        }
        
        if current.count == 10 {
            current.removeLast()
        }
        
        current = [text] + current
        
        Defaults[\.recentSearchTexts] = current
        
        self.viewModel.input!.reloadRecentSearchTexts.accept(())
    }
    
    private func deleteSearchText(text: String) {
        if let first = Defaults[\.recentSearchTexts].firstIndex(of: text) {
            Defaults[\.recentSearchTexts].remove(at: first)
            self.viewModel.input!.reloadRecentSearchTexts.accept(())
        }
    }
    
    private func showPostMenu(menuButtonFrame: CGRect, post: Post) {
        guard !isPostMenuOpen else { return }
        
        self.postMenuView.post = post
        self.postMenuView.removeFromSuperview()
        self.isPostMenuOpen = true
        
        postMenuView.frame = CGRect(
            x: menuButtonFrame.maxX - 126.0,
            y: menuButtonFrame.origin.y + 58.0,
            width: 112.0,
            height: 146.0
        )
        
        self.searchResultCollectionView.addSubview(postMenuView)
    }
    
    private func dismissPostMenu() {
        if self.isPostMenuOpen {
            self.postMenuView.removeFromSuperview()
            self.isPostMenuOpen = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first?.view else { return }
        
        self.dismissPostMenu()
    }
    
    private func showDeleteAlert() {
        self.view.endEditing(true)
        
        let alert = TwoButtonAlertController(title: "정말 삭제하시겠어요?", content: "삭제한 취향은 복구할 수 없어요.", okButtonTitle: "뒤로 가기", cancelButtonTitle: "삭제 하기")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        alert.okButton.rx.tap
            .bind {
                alert.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
        
        alert.cancelButton.rx.tap
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self, let post = self.postMenuView.post else { return Observable.just(false) }
                
                return PostServices.deletePost(post: post)
            }
            .bind { [weak self] in
                guard let self, let post = self.postMenuView.post else { return }
                
                guard $0, let index = self.viewModel.output?.searchResults.value.firstIndex(where: {
                    post.id == $0.id
                }) else {
                    self.dismissPostMenu()
                    alert.dismiss(animated: true)
                    return
                }
                
                var array = self.viewModel.output!.searchResults.value
                array.remove(at: index)
                self.viewModel.output?.searchResults.accept(array)
                self.dismissPostMenu()
                alert.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.present(alert, animated: true)
    }
    
}

extension SearchPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = self.viewModel.output!.searchResults.value[indexPath.item]
        
        if post.content == "" {
            return CGSize(width: Constants.DeviceWidth - 40.0, height: 187.0)
        } else {
            return CGSize(width: Constants.DeviceWidth - 40.0, height: 335.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismissPostMenu()
    }
}
