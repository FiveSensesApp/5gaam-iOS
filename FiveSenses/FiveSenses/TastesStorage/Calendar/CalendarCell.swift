//
//  CalendarCell.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/26.
//

import UIKit

import FSCalendar

class CalendarCell: FSCalendarCell {
    static let identifier = "CalendarCell"
    
    var indicator = UIImageView()
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(indicator)
        self.indicator.then {
            $0.image = UIImage.color(.gray03)
            $0.makeCornerRadius(radius: 3.0)
        }.snp.makeConstraints {
            $0.width.height.equalTo(6.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(3.0)
        }
    }
    
}
