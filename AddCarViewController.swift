//
//  AddCarViewController.swift
//  CourceWork3year
//
//  Created by Алексей on 09.01.2023.
//

import UIKit

class AddCarViewController: MenuViewController {
    @IBOutlet weak var titleTextField: DesignableUITextField!
    @IBOutlet weak var descriptionTextField: DesignableUITextField!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBGView(view: bgView)
        setPopGestureRecognizer()
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

    @IBAction func onBackButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCreateCarbuttonClick(_ sender: Any) {
        
        if !titleTextField.hasText{
            titleTextField.borderColor = .red
        }
        if !descriptionTextField.hasText{
            descriptionTextField.borderColor = .red
        }
        
        if titleTextField.hasText && descriptionTextField.hasText
        {
            requests.createCar(title: titleTextField.text!, description: descriptionTextField.text!){ status in
                DispatchQueue.main.async { [self] in
                    if status{
                        navigationController?.popViewController(animated: true)
                    }else{
                        titleTextField.borderColor = .red
                        descriptionTextField.borderColor = .red
                    }
                }
            }
        }
    }
}
