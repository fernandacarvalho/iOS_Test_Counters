//
//  UIColor+Extension.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 18/06/21.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
//    static let accentColor = UIColor(named: "AccentColor") ?? UIColor(hexString: "#FF9500")
//    static let background = UIColor(named: "Background") ?? UIColor(hexString: "#ECECEC")
//    static let buttonText = UIColor(named: "ButtonText") ?? UIColor(hexString: "#FFFFFF")
//    static let descriptionText = UIColor(named: "descriptionText") ?? UIColor(hexString: "#FFFFFF")
    
    @Theme(light: UIColor(named: "AccentColor") ?? UIColor(hexString: "#FF9500"),
               dark: UIColor(named: "AccentColor") ?? UIColor(hexString: "#FF9500"))
        static var accentColor: UIColor
    
    @Theme(light: UIColor(named: "Background") ?? UIColor(hexString: "#ECECEC"),
               dark: UIColor(named: "Background") ?? UIColor(hexString: "#ECECEC"))
        static var background: UIColor
    
    @Theme(light: UIColor(named: "ButtonText") ?? UIColor(hexString: "#FFFFFF"),
               dark: UIColor(named: "ButtonText") ?? UIColor(hexString: "#FFFFFF"))
        static var buttonText: UIColor
    
    @Theme(light: UIColor(named: "descriptionText") ?? UIColor(hexString: "#2B2B2B"),
               dark: UIColor(named: "descriptionText") ?? UIColor(hexString: "#D3D3D3"))
        static var descriptionText: UIColor
    
    @Theme(light: UIColor(named: "DisabledText") ?? UIColor(hexString: "#DCDCDF"),
               dark: UIColor(named: "DisabledText") ?? UIColor(hexString: "#DCDCDF"))
        static var disabledText: UIColor
    
    @Theme(light: UIColor(named: "Green") ?? UIColor(hexString: "#4BD963"),
               dark: UIColor(named: "Green") ?? UIColor(hexString: "#4BD963"))
        static var green: UIColor
    
    @Theme(light: UIColor(named: "PrimaryText") ?? UIColor(hexString: "#000000"),
               dark: UIColor(named: "PrimaryText") ?? UIColor(hexString: "#000000"))
        static var primaryText: UIColor
    
    @Theme(light: UIColor(named: "Red") ?? UIColor(hexString: "#FF3A2F"),
               dark: UIColor(named: "Red") ?? UIColor(hexString: "#FF3A2F"))
        static var red: UIColor
    
    @Theme(light: UIColor(named: "SecondaryText") ?? UIColor(hexString: "#878A90"),
               dark: UIColor(named: "SecondaryText") ?? UIColor(hexString: "#878A90"))
        static var secondaryText: UIColor
    
    @Theme(light: UIColor(named: "SubtitleText") ?? UIColor(hexString: "#4A4A4A"),
               dark: UIColor(named: "SubtitleText") ?? UIColor(hexString: "#CBCBCB"))
        static var subtitleText: UIColor
    
    @Theme(light: UIColor(named: "Yellow") ?? UIColor(hexString: "#FFCC00"),
               dark: UIColor(named: "Yellow") ?? UIColor(hexString: "#FFCC00"))
        static var yellow: UIColor
}

@propertyWrapper
struct Theme {
    let light: UIColor
    let dark: UIColor

    var wrappedValue: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return self.dark
                } else {
                    return self.light
                }
            }
        } else {
            return self.light
        }
    }
}


