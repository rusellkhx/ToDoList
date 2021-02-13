//
//  Alert.swift
//  ToDo
//
//  Created by Rusell on 30.01.2021.
//

import UIKit

class AlertController: UIAlertController {

    var buttonBackgroundColor: UIColor = .darkGray {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.allViews.forEach {
            if let color = $0.backgroundColor, color != .clear {
                $0.backgroundColor = buttonBackgroundColor
            }
            
            if let visualEffectView = $0 as? UIVisualEffectView {
                visualEffectView.effect = nil
                visualEffectView.backgroundColor = buttonBackgroundColor
            }
        }
        popoverPresentationController?.backgroundColor = buttonBackgroundColor
    }
}
extension UIView {
    
    fileprivate var allViews: [UIView] {
        var views = [self]
        subviews.forEach {
            views.append(contentsOf: $0.allViews)
        }
        return views
    }
}
