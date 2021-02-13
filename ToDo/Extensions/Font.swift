//
//  Font.swift
//  CurrencyRates
//
//  Created by Rusell on 30.01.2021.
//

import UIKit

extension UIFont {
    
    static private let familyFont = "OpenSans-"
    
    enum AssetsFont: String {
        case semibold = "Semibold"
        case light = "Light"
        case italic = "Italic"
        case extraBold = "ExtraBold"
        case lightItalic = "LightItalic"
        case bold = "Bold"
        case semiboidItalic = "SemiboldItalic"
        case extraBoldItalic = "ExtraBoldItalic"
        case regular = "Regular"
        case boldItalic = "BoldItalic"
    }
    
    static func appFont(_ name: AssetsFont, size: CGFloat = 14) -> UIFont {
        
        guard let font = UIFont(name: familyFont + name.rawValue, size: size) else {
            print("Error: font \(familyFont + name.rawValue) not found")
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}

