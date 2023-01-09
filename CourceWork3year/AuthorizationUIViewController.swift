//
//  AuthorizationUIViewController.swift
//  SwapProject
//
//  Created by alexey on 30.08.2022.
//

import UIKit

class AuthorizationUIViewController: MenuViewController{
    enum AuthorizationType: Int{
        case email = 0
        case phone = 1
    }
    
    var iconClick = true

    private var passwordTextField: DesignableUITextField!
    private var phoneEmailSegmentedControl: UISegmentedControl!
    
    let closeImageIcon = UIImage(systemName: "eye.slash")
    let openImageIcon = UIImage(systemName: "eye")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    public func setTextField(textField: DesignableUITextField){
        uiKit.setShadowAndCorners(shadowLayer: textField)
        textField.delegate = self
    }
    
    public func setPasswordTextField(passwordTextField: DesignableUITextField){
        self.passwordTextField = passwordTextField
        uiKit.setShadowAndCorners(shadowLayer: passwordTextField)
        let button = UIButton(type: .custom)
        button.setImage(openImageIcon, for: .normal)
        let contentView = UIView()
        contentView.addSubview(button)

        let buttonWidth = 20
        let buttonHeight = 15
        contentView.frame = CGRect(x: 0, y: 0, width: buttonWidth + 16, height: buttonHeight)
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)

        self.passwordTextField.rightView = contentView
        self.passwordTextField.rightViewMode = .always

        button.addTarget(self, action: #selector(self.hideButtonTapped), for: .touchUpInside)
    }
    
    @IBAction func hideButtonTapped(_ sender: UIButton) {

        if iconClick
        {
            iconClick = false
            sender.setImage(closeImageIcon, for: .normal)
        }
        else
        {
            iconClick = true
            sender.setImage(openImageIcon, for: .normal)
        }
        
        passwordTextField.isSecureTextEntry = iconClick
    }
}

extension AuthorizationUIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
