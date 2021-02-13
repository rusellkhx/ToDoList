//
//  Image.swift
//  CurrencyRates
//
//  Created by Rusell on 30.01.2021.
//

import UIKit

extension UIImage {
    
    enum AssetImage: String {
        
        case creditcard
        case wallet = "wallet.pass.fill"
        
    }
    
    static func appImage(_ name: AssetImage) -> UIImage {
        
        guard let image = UIImage(named: name.rawValue) else {
            print("Error: image \(name.rawValue) not found")
            return UIImage()
        }
        
        return image
    }
}

extension UIImageView
{
    func getFileName() -> String? {
        let imgName = self.image?.accessibilityIdentifier
        return imgName
    }
}


