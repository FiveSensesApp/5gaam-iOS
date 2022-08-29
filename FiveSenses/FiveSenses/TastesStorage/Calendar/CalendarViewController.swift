//
//  CalendarViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/25.
//

import UIKit

import FSCalendar
import RxSwift
import RxCocoa

class CalendarViewController: BaseTastesViewController {
    lazy var adapter = Adapter(collectionView: self.tastesCollectionView)
    var viewModel = TastesStorageViewModel()
    lazy var calendarView = FSCalendar(frame: CGRect(x: 0, y: 0, width: Constants.DeviceWidth, height: 141.0))
    
    var calendarLeftButton = UIButton()
    var calendarRightButton = UIButton()
    
    var calendarExpandButton = CalendarExpandButton()
    
    private var disposeBag = DisposeBag()
    
    var first = true
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(calendarView)
        calendarStyle()
        _ = self.calendarView.then {
            $0.delegate = self
            $0.dataSource = self
            $0.setScope(.week, animated: false)
            $0.scrollEnabled = false
            $0.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
//            $0.appearance.todaySelectionColor = .white
            $0.appearance.selectionColor = .red02
            $0.appearance.todayColor = .white
            $0.appearance.todaySelectionColor = .red02
            $0.appearance.titleTodayColor = .red02
            $0.select(Date())
        }
        
        self.view.addSubview(calendarExpandButton)
        self.calendarExpandButton.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom)
            $0.height.equalTo(46.0)
            $0.left.right.equalToSuperview()
        }
        
        self.tastesCollectionView.snp.remakeConstraints {
            $0.top.equalTo(self.calendarExpandButton.snp.bottom).offset(12.0)
            $0.left.right.bottom.equalToSuperview()
        }
        
        self.tastesCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 29.0, right: 0.0)
        }
        
        self.firstWriteView.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        if first {
            self.calendarExpandButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30.0, isShadowOn: true)
            first.toggle()
        } else {
            var shadowLayer = CALayer()
            for layer in self.view.layer.sublayers ?? [] {
                if let _ = layer.shadowPath {
                    shadowLayer = layer
                    break
                }
            }
            
            shadowLayer.frame = self.calendarExpandButton.frame
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adapter.delegate = self
        self.tastesCollectionView.delegate = self.adapter
        self.tastesCollectionView.dataSource = self.adapter
        
        self.adapter.reload(sections: self.viewModel.toCollectionSections(cellType: KeywordTastesCell.self))
        
        
        self.calendarView.addSubview(calendarLeftButton)
        _ = self.calendarLeftButton.then {
            $0.setImage(UIImage(named: "왼쪽꺽쇠"), for: .normal)
            $0.frame = CGRect(x: 6.0, y: 2.5, width: 44.0, height: 44.0)
        }
        
        self.calendarView.addSubview(calendarRightButton)
        _ = self.calendarRightButton.then {
            $0.setImage(UIImage(named: "오른쪽꺽쇠"), for: .normal)
            $0.frame = CGRect(x: 150.0, y: 2.5, width: 44.0, height: 44.0)
        }
        
        self.calendarExpandButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                if self?.calendarView.scope == .month {
                    self?.calendarView.setScope(.week, animated: false)
                } else {
                    self?.calendarView.setScope(.month, animated: false)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func calendarStyle() {
        
        //언어 한국어로 변경
        calendarView.locale = Locale(identifier: "ko_KR")

        //MARK: -상단 헤더 뷰 관련
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 //헤더 좌,우측 흐릿한 글씨 삭제
        calendarView.appearance.headerDateFormat = "YYYY년 M월" //날짜(헤더) 표시 형식
        calendarView.appearance.headerTitleColor = .black //2021년 1월(헤더) 색
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24) //타이틀 폰트 크기
        
        
        //MARK: -캘린더(날짜 부분) 관련
        calendarView.backgroundColor = .white // 배경색
//        calendarView.appearance.weekdayTextColor = .gray03 //요일(월,화,수..) 글씨 색
//        calendarView.appearance.selectionColor = .calendarSelectCircleGrey //선택 된 날의 동그라미 색
//        calendarView.appearance.titleWeekendColor = .black //주말 날짜 색
//        calendarView.appearance.titleDefaultColor = .black //기본 날짜 색
        
        
        //MARK: -오늘 날짜(Today) 관련
//        calendarView.appearance.titleTodayColor = .seaweed //Today에 표시되는 특정 글자색
        calendarView.appearance.todayColor = .red02 //Today에 표시되는 선택 전 동그라미 색
        calendarView.appearance.todaySelectionColor = .none  //Today에 표시되는 선택 후 동그라미 색
        
        
        // Month 폰트 설정
        calendarView.appearance.headerTitleFont = .bold(18.0)
        calendarView.appearance.headerTitleColor = .gray04
        calendarView.headerHeight = 44.0
        
        // week
        calendarView.appearance.weekdayFont = .medium(14.0)
        calendarView.appearance.weekdayTextColor = .gray03
        calendarView.weekdayHeight = 21.0
        
        // day 폰트 설정
        calendarView.appearance.titleFont = .semiBold(16.0)
        calendarView.rowHeight = 44.0
        
        calendarView.collectionViewLayout.sectionInsets = .zero
        
        
        
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: date, at: position) as! CalendarCell
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if bounds.size.height > 140.0 {
            let calendarFrame = CGRect(x: 0, y: calendar.fs_top, width: bounds.size.width, height: 376.0)
            calendarView.frame = calendarFrame
        } else {
            let calendarFrame = CGRect(x: 0, y: calendar.fs_top, width: bounds.size.width, height: 141.0)
            calendarView.frame = calendarFrame
        }
        
        calendarView.reloadData()
//        self.calendarExpandButton.setNeedsLayout()
    }
    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        FSCalendarCell().then {
//            $0.backgroundColor = .red
//        }
//    }
    
    
    // 이벤트 밑에 Dot 표시 개수
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if self.eventsArray.contains(date){
//            return 1
//        }
//        if self.eventsArray_Done.contains(date){
//            return 1
//        }
//
//        return 0
//    }
//
//    // Default Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
//        if self.eventsArray.contains(date){
//            return [UIColor.green]
//        }
//
//        if self.eventsArray_Done.contains(date){
//            return [UIColor.red]
//        }
//
//        return nil
//    }
//
//    // Selected Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
//        if self.eventsArray.contains(date){
//            return [UIColor.green]
//        }
//
//        if self.eventsArray_Done.contains(date){
//            return [UIColor.red]
//        }
//
//        return nil
//    }
    
    // Event 표시 Dot 사이즈 조정
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let eventScaleFactor: CGFloat = 1.8
//        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
//        return CGPoint(x: 0, y: 3)
//    }
}

extension CalendarViewController: AdapterDelegate {
    func configure(model: Any, view: UIView, indexPath: IndexPath) {
        guard let model = model as? Model else { return }
        
        switch (model, view) {
        case (.header(let count), let view as TastesTotalCountHeaderView):
            view.totalCountLabel.text = "총 \(count)개"
        case (.post(let post), let cell as KeywordTastesCell):
            cell.configure(post: post)
        default:
            break
        }
    }
    
    func select(model: Any) {
        
    }
    
    func size(model: Any, containerSize: CGSize) -> CGSize {
        guard let model = model as? Model else { return .zero }
        
        switch model {
        case .header:
            return CGSize(width: Constants.DeviceWidth, height: 12.0)
        case .post:
            return CGSize(width: Constants.DeviceWidth - 40.0, height: 50.0)
        }
    }
}
