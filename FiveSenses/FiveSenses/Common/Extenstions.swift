//
//  Extenstions.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/20.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

// MARK: - 기본 컬러 프리셋
extension UIColor {
    static var white = UIColor(hex: "FFFFFF")
    static var gray01 = UIColor(hex: "F4F4F3")
    static var gray02 = UIColor(hex: "D1D3CF")
    static var gray03 = UIColor(hex: "BBBDB6")
    static var gray04 = UIColor(hex: "82857A")
    static var black = UIColor(hex: "1B210D")
    static var red01 = UIColor(hex: "FFDAE2")
    static var red02 = UIColor(hex: "FF6E83")
    static var red03 = UIColor(hex: "974650")
    static var blue01 = UIColor(hex: "DCF5FF")
    static var blue02 = UIColor(hex: "3AC5FF")
    static var blue03 = UIColor(hex: "3B749F")
    static var green01 = UIColor(hex: "E1FED2")
    static var green02 = UIColor(hex: "A4E33D")
    static var green03 = UIColor(hex: "6A8B37")
    static var yellow01 = UIColor(hex: "FEF6CD")
    static var yellow02 = UIColor(hex: "F9D63F")
    static var yellow03 = UIColor(hex: "998537")
    static var purple01 = UIColor(hex: "E8E0FF")
    static var purple02 = UIColor(hex: "A586FF")
    static var purple03 = UIColor(hex: "60509E")
}

// MARK: - 기본 폰트 프리셋
extension UIFont {
    static func semiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size)!
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size)!
    }
}
 
extension UIView {
    func makeCornerRadius(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, isShadowOn: Bool = false) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if isShadowOn {
            let shadowLayer = makeShadowLayer(offset: CGSize(width: 0, height: 5), color: .lightGray, opacity: 0.1, radius: 1.0)
            shadowLayer.shadowPath = path.cgPath
            shadowLayer.frame = self.frame
            self.superview!.layer.insertSublayer(shadowLayer, below: self.layer)
        }
    }
    
    func getRoundCornerPath(corners: UIRectCorner, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    }
}

extension UIImage {
    public static func color(_ color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        if let string = self {
            return string.isEmpty
        } else {
            return true
        }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        if let array = self {
            return array.isEmpty
        } else {
            return true
        }
    }
}

extension UIView {
    enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    func addShadow(location: VerticalLocation, color: UIColor = .white, opacity: Float = 0.2, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func makeShadowLayer(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) -> CALayer {
        let layer = CALayer()
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        
        return layer
    }
}

// MARK: - String <-> Date 변환
enum DateFormatType: String {
    /// 7.2 (화) 오전 4:20
    case CategoryHeader = "M.d (E) a hh:mm"
    /// 2022.12.23
    case WriteView = "yyyy.MM.dd"
    /// 2022-08-05T14:54:43.19
    case Server = "yyyy-MM-dd'T'HH:mm:ss"
    /// 12월 11일
    case ModifyPost = "MM월 dd일"
    /// 2022-09-11
    case Parameter = "yyyy-MM-dd"
    /// 5월
    case OnlyMonth = "M월"
}

extension String {
    func toDate(format: DateFormatType) -> Date? {
        var string = self
        if format == .Server {
            string = String(string.prefix(22))
        }
        print(string, format.rawValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: string)
    }
}

extension Date {
    func toString(format: DateFormatType) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func addComponent(value: Int, component: Calendar.Component) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: self) ?? self
    }
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
    
    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }
    
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }
    
    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

extension UIImage {
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}

extension UIWindow {
    
    func replaceRootViewController(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)
        
        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            
            if animated {
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            }
            
            else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        
        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        }
        else {
            dismissCompletion()
        }
    }
    
    
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage.init() }
        UIGraphicsEndImageContext()
        return result
    }
}

extension SignTextFieldType {
    var textRule: String {
        switch self {
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .password:
            return "((?=.*[A-Za-z])|(?=.*[0-9]))|((?=.*[0-9])|(?=.*[!@#$&*]))|((?=.*[A-Za-z])|(?=.*[!@#$&*])).{10,20}"
        case .none:
            return ""
        case .nickname:
            return "[가-힣A-Za-z0-9]{2,8}"
        }
    }
}

