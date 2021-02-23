//
//  UIViewController.swift
//  ToDo
//
//  Created by Rusell on 30.01.2021.
//

import UIKit

extension UIView {
    
    class var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
    func create<T: UITableViewCell>(_ cell: T.Type, _ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.identifier, bundle: nil), forCellWithReuseIdentifier: T.identifier)
    }
    func create<T: UICollectionViewCell>(_ cell: T.Type, _ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! T
    }
}

extension UIViewController {
    
    func showMessageAlert(_ message: String) {
        self.showAlert(title: nil, message: message, completion: {})
    }
    
    func showChoiceAlert(title: String? , message: String?, customActions: [UIAlertAction]) {
        self.showAlert(title: title, message: message, customActions: customActions, completion: {})
    }
    
    func showAlert(title: String?, message: String?, customActions: [UIAlertAction] = [], completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            let alert = AlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.buttonBackgroundColor = UIColor.appColor(.viewAlert)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in completion()}))
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addTask(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alert = AlertController(title: title, message: message, preferredStyle: style)
        alert.buttonBackgroundColor = UIColor.appColor(.viewAlert)
        alert.addTextField { tf in
        }
        
        let add = UIAlertAction(title: Description.Alert.addNewTask, style: .default) { action in
            let textField = alert.textFields?.first
            guard let task = textField?.text else { return }
            if task != "" {
                let task = task.split(separator: " ").joined(separator: "%20")
                completionHandler(task)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func printMessage(function: String = #function) {
        print("\(title ?? ""): \(function)")
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as? UIScrollView)?.contentSize = CGSize(width: self.view.bounds.size.width,
                                                          height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as? UIScrollView)?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0,
                                                                          bottom: kbFrameSize.height,
                                                                          right: 0)
        
    }
    
    @objc func kbDidHide() {
        (self.view as? UIScrollView)?.contentSize = CGSize(width: self.view.bounds.size.width,
                                                          height: self.view.bounds.size.height)
    }
    
    func addTapGestureToHideKeyboard() {
           let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
           view.addGestureRecognizer(tapGesture)
    }

}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}






