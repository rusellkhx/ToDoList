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
        
        addTapGestureToHideKeyboard()
        startElementsInTextField()
        registerForKeyboardNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBiginTextInTextField(textUITextField: newLoginTextField)
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
}

//MARK: UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    
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
