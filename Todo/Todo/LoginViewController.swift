//
//  LoginViewController.swift
//  TODO
//
//  Created by Valton Sherifi on 7/10/20.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        guard
            let email = textFieldLoginEmail.text,
            let password = textFieldLoginPassword.text,
            email.count > 0,
            password.count > 0
            else {
                let alertContoller = UIAlertController (title: "Error" , message: "Error Message " , preferredStyle:UIAlertController.Style.alert)
                alertContoller.addAction(UIAlertAction(title: "OK", style:UIAlertAction.Style.default , handler: nil))
                present(alertContoller, animated: true, completion: nil)
                return
        }
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
    }
