//
//  LoginViewController.swift
//  TODO
//
//  Created by Valton Sherifi on 7/10/20.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//

import UIKit
import Firebase

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
    //Krijimi i autintifikimit me dy parametra: auth dhe user
    Auth.auth().addStateDidChangeListener() { auth, user in
    //nese user nuk eshte nil vazhdo
      if user != nil {
        //Me ane te metodes performSegue kalohet nga nje screen ne tjetrin duke i caktuar identifikuesin
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
        //Zbrazja e te dhenave pasi qe logini te jete ne rregull
        self.textFieldLoginEmail.text = nil
        self.textFieldLoginPassword.text = nil
      }
    }
  }

    // //Eshte variabel e cila i jep funksionalitet butonit te loginit
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    //Kontrollohen te dhenat e textfieldave email dhe password, nese nuk kan te dhana nuk vazhdohet me tutje
    guard
      let email = textFieldLoginEmail.text,
      let password = textFieldLoginPassword.text,
      email.count > 0,
      password.count > 0
      else {
        return
    }
    //Verifikimi i vlerave te userit, pas verifikimit te sukseshem  te dhenat jane te shtuara me sukses
    Auth.auth().signIn(withEmail: email, password: password) { user, error in
      if let error = error, user == nil {
        let alert = UIAlertController(title: "Sign In Failed",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
}
