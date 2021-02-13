//
//  UIColor.swift
//  CurrencyRates
//
//  Created by Rusell on 30.01.2021.
//

import UIKit

extension UIColor {
    
    enum AssetsColor: String {
        case viewAlert
        case navBar
    }
    
    static func appColor(_ name: AssetsColor) -> UIColor {
        
        guard let color = UIColor(named: name.rawValue) else {
            print("Error: color \(name.rawValue) not found")
            return .red
        }
        
        return color
    }
}
