//
//  RegistrationViewController.swift
//  ToDo
//
//  Created by Rusell on 06.02.2021.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    let storageSrvice: StorageServiceProtocol = StorageService()
    
    @IBOutlet weak var newLoginTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordRepeatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startElementsInTextField()
        registerForKeyboardNotifications()
        setupView()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBiginTextInTextField()
    }
    
    //MARK: IBAction func
    @IBAction func pressedToGoRegistration(_ sender: UIButton) {
        checkRegistration()
    }
    
    @IBAction func pressedToGoLoginVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private func
    private func startElementsInTextField() {
        newLoginTextField.delegate = self
        newLoginTextField.tag = TextFieldTag.login.rawValue
        
        newPasswordTextField.delegate = self
        newPasswordTextField.tag = TextFieldTag.password.rawValue
        
        newPasswordRepeatTextField.delegate = self
        newPasswordRepeatTextField.tag = TextFieldTag.passwordRepeat.rawValue
    }
    
    private func startBiginTextInTextField() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.newLoginTextField.becomeFirstResponder()
        }
    }
    
    private func checkRegistration() {
        view.endEditing(true)
        guard let login = newLoginTextField.text,
              let password = newPasswordTextField.text,
              let passwordRepeat = newPasswordRepeatTextField.text,
              login != "",
              password != "",
              passwordRepeat != "" else {
            showMessageAlert(ShowMessage.ErrorRegistration.errorRegistarion)
            return
        }
        if password != passwordRepeat {
            showMessageAlert(ShowMessage.ErrorRegistration.errorPasswordRepeat)
        } else {
            showMessageAlert(storageSrvice.addUser(login, password))
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    private func setupView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleTap(_:))))
    }
}

//MARK: UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                          height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0,
                                                                          bottom: kbFrameSize.height,
                                                                          right: 0)
    }
    
    @objc private func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                          height: self.view.bounds.size.height)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 0 else {
            return false
        }
        
        switch textField.tag {
        case TextFieldTag.login.rawValue:
            newPasswordTextField.becomeFirstResponder()
        case TextFieldTag.password.rawValue:
            newPasswordRepeatTextField.becomeFirstResponder()
        case TextFieldTag.passwordRepeat.rawValue:
            checkRegistration()
        default:
            return false
        }
        return true
    }
}
