//
//  LoginViewController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 10.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = "Enter your account:"
        loginLabel.text = "Login:"
        passwordLabel.text = "Password:"
        loginTextField.placeholder = "Login"
        passwordTextField.placeholder = "Password"
        
        loginButton.setTitle("Log In", for: .normal)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //subscribing on two notification(kboard appear and disappear)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // keyboard appears
    @objc func keyboardWasShown(notification: Notification) {
        //get the keyboard size
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        //indent bottom UISrollView = kboard size
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    //keyboard disappears
    @objc func keyboardWillHidden(notification: Notification) {
        //indent bottom = 0
        let contentInsets = UIEdgeInsets.zero
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "fromLoginController" {
            let dataIsRight = usersDataIsRight()
            if !dataIsRight {
                showEnterError()
            }
            return usersDataIsRight()
        }
        return true
    }
    
    func usersDataIsRight() -> Bool {
        guard let login = loginTextField.text else { return false }
        guard let password = passwordTextField.text else { return false }
       return login == "" && password == ""
    }
    
    func showEnterError() {
        let alert = UIAlertController(title: "Error!", message: "Введены неверные данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //It`s necessary also unsubscribe from notifications
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

