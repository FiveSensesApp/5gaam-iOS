//
//  TermsViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/23.
//

import UIKit

class TermsViewController: BaseSettingViewController {
    var fiveSenseTermsButtonView = SettingButtonView()
    var serviceTermsButtonView = SettingButtonView()
    var privacyButtonView = SettingButtonView()
    
    private var termsLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        
        self.navigationBarView.title = "이용약관"
        
        self.view.addSubview(fiveSenseTermsButtonView)
        self.fiveSenseTermsButtonView.then {
            $0.backgroundColor = .white
            $0.title = "‘오감' 이용약관"
        }.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom).offset(9.0)
            $0.left.right.equalToSuperview().inset(28.0)
            $0.height.equalTo(50.0)
        }
        
        let lineview1 = UIView()
        
        self.view.addSubview(lineview1)
        lineview1.then {
            $0.backgroundColor = .gray02
        }.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.top.equalTo(self.fiveSenseTermsButtonView.snp.bottom).offset(9.0)
        }
        
        self.view.addSubview(serviceTermsButtonView)
        self.serviceTermsButtonView.then {
            $0.backgroundColor = .white
            $0.title = "개인정보처리방침"
        }.snp.makeConstraints {
            $0.top.equalTo(lineview1.snp.bottom).offset(9.0)
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
            $0.title = "마케팅 정보 수신"
        }.snp.makeConstraints {
            $0.top.equalTo(lineview.snp.bottom).offset(9.0)
            $0.left.right.equalToSuperview().inset(28.0)
            $0.height.equalTo(50.0)
        }
        
        _ = termsLabel.then {
            $0.numberOfLines = 0
            $0.font = .regular(14.0)
            $0.textColor = .gray04
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fiveSenseTermsButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.termsLabel.text = """
    제 1조 (목적)
    이 약관은 오감(이하 ‘서비스’라 합니다)와 이용계약을 체결한 ‘고객’이 이용함에 있어 필요한 서비스와 고객의 권리 및 의무, 기타 제반 사항을 정함을 목적으로 합니다.

    제 2조 (약관 외 준칙)
    이 약관에 명시되지 않은 사항에 대해서는 위치 정보의 보호 및 이용 등에 관한 법률, 전기통신사업법, 정보통신망 이용 촉진 및 보호 등에 관한 법률 등 관계법령 및 서비스가 정한 서비스의 세부이용지침 등의 규정에 따릅니다.

    제 3조 (가입자격)
    ①서비스에 가입할 수 있는 자는 ‘오감’을 설치가능한 모든 사람입니다.

    제 4조 (서비스 가입)
    ①오감 관리자가 정한 본 약관에 고객이 동의하면 서비스 가입의 효력이 발생합니다.
    ②오감 관리자는 다음 각 호의 고객 가입신청에 대해서는 이를 승낙하지 아니할 수 있습니다.
         1. 고객 등록 사항을 누락하거나 오기하여 신청하는 경우
         2. 공공질서 또는 미풍양속을 저해하거나 저해할 목적으로 신청한 경우
         3. 기타 서비스가 정한 이용신청 요건이 충족되지 않았을 경우

    제 5조 (서비스의 탈퇴)
    서비스 탈퇴를 희망하는 고객은 오감 담당자가 정한 소정의 절차(설정메뉴의 탈퇴)를 통해 서비스 해지를 신청할 수 있습니다.
     
     제 6조 (서비스의 수준)
    ① 서비스의 이용은 연중무휴 1일 24시간을 원칙으로 합니다. 단, 서비스의 업무상이나 기술상의 이유로 서비스가 일시 중지될 수 있으며, 운영상의 목적으로 서비스가 정한 기간에는 서비스가 일시 중지될 수 있습니다. 이러한 경우 서비스는 사전 또는 사후에 이를 공지합니다.
    ② 위치정보는 관련 기술의 발전에 따라 오차가 발생할 수 있습니다.

    제 7조 (서비스 이용의 제한 및 정지)
    서비스는 고객이 다음 각 호에 해당하는 경우 사전 통지 없이 고객의 서비스 이용을 제한 또는 정지하거나 직권 해지를 할 수 있습니다.
         1. 타인의 서비스 이용을 방해하거나 타인의 개인정보를 도용한 경우
         2. 서비스를 이용하여 법령, 공공질서, 미풍양속 등에 반하는 행위를 한 경우

    제 8조 (서비스의 변경 및 중지)
    ① 서비스는 다음 각 호의 1에 해당하는 경우 고객에게 서비스의 전부 또는 일부를 제한, 변경하거나 중지할 수 있습니다.
         1. 서비스용 설비의 보수 등 공사로 인한 부득이한 경우
         2. 정전, 제반 설비의 장애 또는 이용량의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우
         3. 서비스 제휴업체와의 계약 종료 등과 같은 서비스의 제반 사정 또는 법률상의 장애 등으로 서비스를 유지할 수 없는 경우
         4.기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우
    ② 제1항에 의한 서비스 중단의 경우에는 서비스는 인터넷 등에 공지하거나 고객에게 통지합니다. 다만, 서비스가 통제할 수 없는 사유로 인한 서비스의 중단 (운영자의 고의, 과실이 없는 디스크 장애, 시스템 다운 등)으로 인하여 사전 통지가 불가능한 경우에는 사후에 통지합니다.

    제 9조 (손해배상)
    ① 고객의 고의나 과실에 의해 이 약관의 규정을 위반함으로 인하여 서비스에 손해가 발생하게 되는 경우, 이 약관을 위반한 고객은 서비스에 발생하는 모든 손해를 배상하여야 합니다.
    ② 고객이 서비스를 이용함에 있어 행한 불법행위나 고객의 고의나 과실에 의해 이 약관 위반행위로 인하여 서비스가 당해 고객 이외의 제3자로부터 손해배상청구 또는 소송을 비롯한 각종 이의제기를 받는 경우 당해 고객은 그로 인하여 서비스에 발생한 손해를 배상하여야 합니다.
    ③ 서비스가 위치정보의 보호 및 이용 등에 관한 법률 제 15조 내지 제26조의 규정을 위반한 행위 혹은 서비스가 제공하는 서비스로 인하여 고객에게 손해가 발생한 경우, 서비스가 고의 또는 과실 없음을 입증하지 아니하면, 고객의 손해에 대하여 책임을 부담합니다.

    제 10조 (면책사항)
    ① 서비스는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.
    ② 서비스는 고객의 귀책사유로 인한 서비스의 이용장애에 대하여 책임을 지지 않습니다.
    ③ 서비스는 고객이 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며, 그 밖에 서비스를 통하여 얻은 자료로 인한 손해 등에 대하여도 책임을 지지 않습니다.
    ④ 서비스에서 제공하는 서비스 및 서비스를 이용하여 얻은 정보에 대한 최종판단은 고객이 직접 하여야 하고, 그에 따른 책임은 전적으로 고객 자신에게 있으며, 서비스는 그로 인하여 발생하는 손해에 대해서 책임을 부담하지 않습니다.
    ⑤ 서비스의 업무상 또는 기술상의 장애로 인하여 서비스를 개시하지 못하는 경우 서비스는 인터넷 홈페이지 등에 이를 공지하거나 E-mail 등의 방법으로 고객에게 통지합니다. 단, 서비스가 통제할 수 없는 사유로 인하여 사전 공지가 불가능한 경우에는 사후에 공지합니다.

    제 11조 (분쟁의 해결 및 관할법원)
    ① 서비스 이용과 관련하여 서비스와 고객 사이에 분쟁이 발생한 경우, 서비스와 고객은 분쟁의 해결을 위해 성실히 협의합니다.
    ② 제1항의 협의에서도 분쟁이 해결되지 않을 경우 양 당사자는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 제33조의 규정에 의한 개인정보분쟁조정위원회에 분쟁조정을 신청할 수 있습니다.


"""
                
                TermsBottomSheet.showBottomSheet(viewController: self, title: "‘오감' 이용약관", label: self.termsLabel, contentHeight: 517.0)
            }
            .disposed(by: self.disposeBag)
        
        self.serviceTermsButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.termsLabel.text = """
    <오감>(이하 '오감')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.

    ○ 이 개인정보처리방침은 2022년 10월 1일부터 적용됩니다.

    제1조(개인정보의 처리 목적)
    < 오감 >(이하 '오감')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

    1. 홈페이지 회원가입 및 관리
    회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지 목적으로 개인정보를 처리합니다.


    제2조(개인정보의 처리 및 보유 기간)
    ① < 오감 >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

    ② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.

    1.<홈페이지 회원가입 및 관리>
    <홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<탈퇴 후 1년>까지 위 이용목적을 위하여 보유. 이용됩니다.

    제3조(개인정보처리 위탁)
    ① < 오감 >은(는) 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.
    1. < Amazon Web Service >
    위탁받는 자 (수탁자) : Amazon Web Service
    위탁하는 업무의 내용 : 데이터 보관
    위탁기간 : 탈퇴 후 1년

    ② < 오감 >은(는) 위탁계약 체결시 「개인정보 보호법」 제26조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적․관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리․감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.

    ③ 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.


    제4조(정보주체와 법정대리인의 권리·의무 및 그 행사방법)
    ① 정보주체는 오감에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.

    ② 제1항에 따른 권리 행사는 오감에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 오감은(는) 이에 대해 지체 없이 조치하겠습니다.

    ③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.

    ④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한될 수 있습니다.

    ⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.

    ⑥ 오감은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.



    제5조(처리하는 개인정보의 항목 작성)
    ① < 오감 >은(는) 다음의 개인정보 항목을 처리하고 있습니다.

    1< 홈페이지 회원가입 및 관리 >
    필수항목 : 이메일, 비밀번호

    제6조(개인정보의 파기)
    ① < 오감 > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.

    ② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.
      보존하는 개인정보 항목 : 이메일, 비밀번호

    ③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.
    1. 파기절차
    < 오감 > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < 오감 > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.

    2. 파기방법
    전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다


    제7조(개인정보의 안전성 확보 조치)
    <오감>은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.

    1. 개인정보에 대한 접근 제한
    개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여, 변경, 말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.


    제8조(개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항)
    <오감>은(는) 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용하지 않습니다.

    제9조 (개인정보 보호책임자)
    ① 오감 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

    ▶ 개인정보 보호책임자
    성명 :최윤찬
    직책 :서버 개발자
    직급 :서버 개발자
    연락처 : hi.mangpo@gmail.com
    ※ 개인정보 보호 담당부서로 연결됩니다.

    제11조(권익침해 구제방법)
    정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.

    1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)
    2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)
    3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)
    4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)

    「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.

    ※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.

    제12조(개인정보 처리방침 변경)

    ①     이 개인정보처리방침은 2022년 1월 31일부터 적용됩니다.

"""
                
                TermsBottomSheet.showBottomSheet(viewController: self, title: "개인정보처리방침", label: self.termsLabel, contentHeight: 517.0)
            }
            .disposed(by: self.disposeBag)
        
        self.privacyButtonView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.termsLabel.text = """
개인정보보호법 제22조 제4항에 의해 선택정보 사항에 대해서는 기재하지 않으셔도 서비스를 이용하실 수 있습니다.

-마케팅 활용 목적
새로운 콘텐츠(기능)의 안내 또는 이벤트 및 프로모션 등 광고성 정보 제공을 위해 본 약관에 동의하신 회원님의 개인정보를 활용합니다.

-전송방법
이메일, 앱푸시 알림 등으로 마케팅 정보를 전달합니다.

-수신 동의 변경
1:1문의 접수를 통해 수신 동의를 변경(동의/철회)할 수 있습니다.

-개인정보 보유 및 이용 기간
이용자의 회원 탈퇴 또는 마케팅 정보 수신 동의 철회 시까지 보유 및 이용합니다.

‘오감’ 서비스를 운용함에 있어 각종 정보를 이메일, 앱푸시 등의 방법으로 회원에게 제공할 수 있으며, 결제안내 등 의무적으로 안내되어야 하는 정보성 내용 및 일부 혜택성 정보는 수신동의 여부와 무관하게 제공합니다.


"""
                
                TermsBottomSheet.showBottomSheet(viewController: self, title: "마케팅 정보 수신", label: self.termsLabel, contentHeight: 517.0)
            }
            .disposed(by: self.disposeBag)
    }
}

final class TermsBottomSheet: BaseBottomSheetController {
    var label: UILabel?
    
    override func loadView() {
        super.loadView()
        
        let scrollView = UIScrollView().then {
            $0.backgroundColor = .white
        }
        
        self.containerView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.cancelButton.snp.bottom).offset(7.0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60.0)
            $0.height.equalTo(self.contentHeight)
        }
        
        let scrollContent = UIView().then {
            $0.backgroundColor = .white
        }
        
        scrollView.addSubview(scrollContent)
        
        scrollContent.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        self.contentView.removeFromSuperview()
        
        if let label = self.label {
            scrollContent.addSubview(label)
            label.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.left.right.equalToSuperview().inset(20.0)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
        if !isUp {
            self.containerView.layoutIfNeeded()
            isUp = true
            
            self.label?.snp.remakeConstraints {
                $0.left.right.equalToSuperview().inset(21.0)
                $0.bottom.equalToSuperview().inset(60.0)
                $0.top.equalToSuperview()
            }
            
            self.containerView.snp.remakeConstraints {
                //                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    class func showBottomSheet(viewController: UIViewController, title: String?, label: UILabel, contentHeight: CGFloat) {
        let vc = TermsBottomSheet(title: title, content: UIView(), contentHeight: contentHeight)
        vc.modalPresentationStyle = .overFullScreen
        vc.label = label
        viewController.present(vc, animated: false)
    }
}
