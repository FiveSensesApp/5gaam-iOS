//
//  TermsViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/23.
//

import UIKit

class TermsViewController: BaseSettingViewController {
    var serviceTermsButtonView = SettingButtonView()
    var privacyButtonView = SettingButtonView()
    
    private var termsLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.title = "이용약관"
        
        self.view.addSubview(serviceTermsButtonView)
        self.serviceTermsButtonView.then {
            $0.backgroundColor = .white
            $0.title = "서비스 이용약관"
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom).offset(9.0)
            $0.left.right.equalToSuperview().inset(28.0)
            $0.height.equalTo(50.0)
        }
        
        let lineview = UIView()
        
        self.view.addSubview(lineview)
        lineview.then {
            $0.backgroundColor = .gray02
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.serviceTermsButtonView.snp.bottom).offset(9.0)
        }
        
        self.view.addSubview(privacyButtonView)
        self.privacyButtonView.then {
            $0.backgroundColor = .white
            $0.title = "개인정보 처리 방침"
        }.snp.makeConstraints {
            $0.top.equalTo(lineview.snp.bottom).offset(9.0)
            $0.left.right.equalToSuperview().inset(28.0)
            $0.height.equalTo(50.0)
        }
        
        _ = termsLabel.then {
            $0.numberOfLines = 0
            $0.text = """
                    1
                    툴이 아닌 틀을 바꾸는 토스팀의 도전은 이제 시작입니다. 저희의 궁극적인 미션은 디지털 제품을 만드는 환경을 바꿈으로써 디지털 제품의 패러다임을 바꿀 수 있는 틀을 만드는 것입니다. 그 과정에서 디자이너가 그림을 그리는 걸 넘어 가치를 디자인하는 환경을 만들 수 있을 테고요. 이를 위해 디자인플랫폼팀에서는 다양한 프로젝트를 준비하고 있습니다.

                    2.
                    먼저, 개발자가 디자인 시안을 다시 구현하지 않도록 하게 하는 툴을 만들고 있습니다. 지금은 디자이너가 디자인 툴을 이용해 디자인하면, 개발자가 똑같은 레이아웃을 코드로 구현하는 생각해보면 비효율적인 방식으로 제품을 개발하고 있는데요. 토스만의 custom Hand-off* 도구를 만든 덕에 디자인을 코드로 옮기는 과정에서 생기는 소통 비용과 반복적인 작업을 극단적으로 최적화할 수 있었어요. 개발자들은 반복적인 UI 작업에서 벗어나, 더 중요한 엔지니어링에 집중할 시간을 확보하

                    1
                    툴이 아닌 틀을 바꾸는 토스팀의 도전은 이제 시작입니다. 저희의 궁극적인 미션은 디지털 제품을 만드는 환경을 바꿈으로써 디지털 제품의 패러다임을 바꿀 수 있는 틀을 만드는 것입니다. 그 과정에서 디자이너가 그림을 그리는 걸 넘어 가치를 디자인하는 환경을 만들 수 있을 테고요. 이를 위해 디자인플랫폼팀에서는 다양한 프로젝트를 준비하고 있습니다.

                    2.
                    먼저, 개발자가 디자인 시안을 다시 구현하지 않도록 하게 하는 툴을 만들고 있습니다. 지금은 디자이너가 디자인 툴을 이용해 디자인하면, 개발자가 똑같은 레이아웃을 코드로 구현하는 생각해보면 비효율적인 방식으로 제품을 개발하고 있는데요. 토스만의 custom Hand-off* 도구를 만든 덕에 디자인을 코드로 옮기는 과정에서 생기는 소통 비용과 반복적인 작업을 극단적으로 최적화할 수 있었어요. 개발자들은 반복적인 UI 작업에서 벗어나, 더 중요한 엔지니어링에 집중할 시간을 확보하

                    1
                    툴이 아닌 틀을 바꾸는 토스팀의 도전은 이제 시작입니다. 저희의 궁극적인 미션은 디지털 제품을 만드는 환경을 바꿈으로써 디지털 제품의 패러다임을 바꿀 수 있는 틀을 만드는 것입니다. 그 과정에서 디자이너가 그림을 그리는 걸 넘어 가치를 디자인하는 환경을 만들 수 있을 테고요. 이를 위해 디자인플랫폼팀에서는 다양한 프로젝트를 준비하고 있습니다.

                    2.
                    먼저, 개발자가 디자인 시안을 다시 구현하지 않도록 하게 하는 툴을 만들고 있습니다. 지금은 디자이너가 디자인 툴을 이용해 디자인하면, 개발자가 똑같은 레이아웃을 코드로 구현하는 생각해보면 비효율적인 방식으로 제품을 개발하고 있는데요. 토스만의 custom Hand-off* 도구를 만든 덕에 디자인을 코드로 옮기는 과정에서 생기는 소통 비용과 반복적인 작업을 극단적으로 최적화할 수 있었어요. 개발자들은 반복적인 UI 작업에서 벗어나, 더 중요한 엔지니어링에 집중할 시간을 확보하
                    """
            $0.font = .regular(14.0)
            $0.textColor = .gray04
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serviceTermsButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                BaseBottomSheetController.showBottomSheet(viewController: self, title: "서비스 이용약관", content: self.termsLabel, contentHeight: 517.0)
            }
            .disposed(by: self.disposeBag)
        
        self.privacyButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                BaseBottomSheetController.showBottomSheet(viewController: self, title: "개인정보 처리 방침", content: self.termsLabel, contentHeight: 517.0)
            }
            .disposed(by: self.disposeBag)
    }
}
