//
//  LoginViewController.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, ConnectionDelegate{
    
    var signupURL = URL(string: "https://auth.udacity.com/sign-up")

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(signupURL!)
    }
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        ConnectionManager.initilizeConnection(delegate: self, email: email, password: password)
        ConnectionManager.login()
    }
    
    func loginSucceeded() {
        print("Hello from login controller, login succeeded!")
    }
    
    func logoutSucceeded() {
        print("Hello from the login controller, logout succeeded")
    }
    
    func serverError(error: String) {
        print("Hello from the login controller, \(error)")
    }
    

}
