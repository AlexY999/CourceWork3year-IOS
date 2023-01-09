//
//  LoginViewController.swift
//  SwapProject
//
//  Created by alexey on 25.08.2022.
//

import UIKit
import LocalAuthentication

class LoginViewController: AuthorizationUIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBGView(view: bgView)
        
        setTextField(textField: emailTextField)
        setPasswordTextField(passwordTextField: passwordTextField)
    }
            
    private func emailSingInCallback(isLogin:Bool)
    {
        print(isLogin)
        DispatchQueue.main.async { [self] in
            if isLogin == false{
                emailTextField.borderColor = .red
                passwordTextField.borderColor = .red
            }
            else
            {
                performSegue(withIdentifier: SegueTags.goToMenuWindowTag.rawValue, sender: nil)
            }
        }
    }
  
    @IBAction func onEnterPassword(_ sender: DesignableUITextField) {
        
        if sender.hasText
        {
            sender.borderColor = .blue
        }
        else
        {
            sender.borderColor = .gray
        }
    }
    
    @IBAction func onSingInButtonClick(_ sender: UIButton) {
        
        if !emailTextField.hasText{
            emailTextField.borderColor = .red
        }
        if !passwordTextField.hasText{
            passwordTextField.borderColor = .red
        }
        
        if emailTextField.hasText && passwordTextField.hasText
        {
            requests.login(email: emailTextField.text!, password: passwordTextField.text!, callback: emailSingInCallback)
            
            print("ID: \(emailTextField.text!) Password \(passwordTextField.text!)")
        }
    }
}

