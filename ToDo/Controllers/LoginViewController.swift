//
//  ViewController.swift
//  ToDo
//
//  Created by Rusell on 06.02.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    let storageSrvice: StorageServiceProtocol = StorageService()
    
    @IBOutlet weak var buttonLogIn: UIButton!
    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        setupView()
        addTapGestureToHideKeyboard()
        checkUserRegistration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldLogin.text = nil
        textFieldPassword.text = nil
    }
    
    //MARK: IBAction func
    @IBAction func pressedRegistration(_ sender: UIButton) {
        pressedRegistration()
    }
    
    @IBAction func pressedLoginIn(_ sender: UIButton) {
        guard let login = textFieldLogin.text,
              let password = textFieldPassword.text,
              login != "",
              password != "" else {
            showMessageAlert(ShowMessage.ErrorRegistration.errorRegistarion)
            return
        }
        if storageSrvice.verificationUser(user: login, password: password) {
            UserDefaults.standard.setValue(login, forKey: "uid")
        
            self.performSegue(withIdentifier: Storyboard.Segue.goToTasks, sender: nil)
        } else {
           showMessageAlert(ShowMessage.ErrorRegistration.errorRegistarion)
        }
    }
    
    //MARK: Private func
    private func setupView() {
        buttonLogIn.layer.cornerRadius = 10
        buttonLogIn.clipsToBounds = true
    }
    
    private func checkUserRegistration() {
        if UserDefaults.standard.bool(forKey: "uid") == true {
            self.performSegue(withIdentifier: Storyboard.Segue.goToTasks, sender: nil)
        }
    }
    
    private func startElements() {
        textFieldLogin.delegate = self
        textFieldLogin.tag = TextFieldTag.login.rawValue
        
        textFieldPassword.delegate = self
        textFieldPassword.tag = TextFieldTag.password.rawValue
    }
    
    private func pressedRegistration() {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: Storyboard.ID.registration) {
            present(viewController, animated: true)
        }
    }
    
}

//MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 0 else {
            return false
        }
        
        switch textField.tag {
        case TextFieldTag.login.rawValue:
            textFieldPassword.becomeFirstResponder()
        case TextFieldTag.password.rawValue:
            pressedRegistration()
        default:
            return false
        }
        return true
    }
    
}
