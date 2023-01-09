//
//  LoginViewController.swift
//  SwapProject
//
//  Created by alexey on 30.08.2022.
//

import UIKit

class RegisterViewController: AuthorizationUIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var firstNameTextField: DesignableUITextField!
    @IBOutlet weak var lastNameTextField: DesignableUITextField!
    
    @IBOutlet weak var minimumCharactersToggle: UIStackView!
    @IBOutlet weak var upperAndLowerCaseCharactersToggle: UIStackView!
    @IBOutlet weak var specialCharactersToggle: UIStackView!
    @IBOutlet weak var oneDigitToggle: UIStackView!
    
    @IBOutlet weak var minimumCharactersText: UILabel!
    @IBOutlet weak var upperAndLowerCaseCharactersText: UILabel!
    @IBOutlet weak var specialCharactersText: UILabel!
    @IBOutlet weak var oneDigitText: UILabel!

    private var isValidPassword = false

    private let minPasswordLength = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        setPopGestureRecognizer()
        
        setBGView(view: bgView)

        setTextField(textField: emailTextField)
        setPasswordTextField(passwordTextField: passwordTextField)

    }
    
    private func emailSingUpCallback(isSingUp:Bool)
    {
        print(isSingUp)
        DispatchQueue.main.async { [self] in
            if isSingUp == false{
                emailTextField.borderColor = .red
                passwordTextField.borderColor = .red
                firstNameTextField.borderColor = .red
                lastNameTextField.borderColor = .red
            }
            else
            {
                performSegue(withIdentifier: SegueTags.goToMenuWindowTag.rawValue, sender: nil)
            }
        }
    }
    
    @IBAction func onSingInButtonClick(_ sender: UIButton) {
        onBackButtonClick(sender)
    }

    @IBAction func onBackButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEnterEmail(_ sender: DesignableUITextField) {
        if sender.hasText
        {
            sender.borderColor = .blue
        }
        else
        {
            sender.borderColor = .gray
        }
    }
    
    
    @IBAction func onEnterPassword(_ sender: DesignableUITextField) {

        print(sender.text as Any)

        isValidPassword = uiKit.checkPassword(textField: sender, upperAndLowerCaseCharactersToggle: upperAndLowerCaseCharactersToggle, oneDigitToggle: oneDigitToggle, specialCharactersToggle: specialCharactersToggle, minimumCharactersToggle: minimumCharactersToggle)

        if sender.hasText
        {
            sender.borderColor = .blue
        }
        else
        {
            sender.borderColor = .gray
        }
    }
    
    @IBAction func onSingUpButtonClick(_ sender: UIButton) {

        if !emailTextField.hasText{
            emailTextField.borderColor = .red
        }
        if !firstNameTextField.hasText{
            emailTextField.borderColor = .red
        }
        if !lastNameTextField.hasText{
            emailTextField.borderColor = .red
        }
        if !isValidPassword{
            passwordTextField.borderColor = .red
        }

        if emailTextField.hasText && isValidPassword && firstNameTextField.hasText && lastNameTextField.hasText
        {
            requests.register(email: emailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, callback: emailSingUpCallback(isSingUp:))

            print("ID: \(emailTextField.text!) Password \(passwordTextField.text!)")
        }
    }
}
