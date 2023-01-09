//
//  MenuViewController.swift
//  SwapProject
//
//  Created by alexey on 26.09.2022.
//

import UIKit

class MenuViewController: UIViewController {
    let uiKit = UIKitAddictional()
    let requests = HTTPRequests()
    
    private var loaingPositionView:UIView?
    private var loadingView:UIView!
    private var loadingActive:Bool = true
    
    // This constraint ties an element at zero points from the bottom layout guide
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    private var normalKeyboardHeightLayoutConstraint: CGFloat?
    private var moveKeyboarPadding:CGFloat? = nil
    private var keybordHideView:UIView? = nil
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    internal func loadInfo(){
        
    }
    
    func setPopGestureRecognizer(){
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setBGView(view:UIView){
//        view.layer.masksToBounds = false
        uiKit.setMaskedCorners(view: view)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardWhenTappedInView(array:[UIView]) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
