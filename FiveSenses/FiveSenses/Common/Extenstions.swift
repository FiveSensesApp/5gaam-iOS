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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
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
}

// MARK: - String <-> Date 변환
enum DateFormatType: String {
    /// 7.2 (화) 오전 4:20
    case CategoryHeader = "M.d (E) a hh:mm"
}

extension String {
    func toDate(format: DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(format: DateFormatType) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}
