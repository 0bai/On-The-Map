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
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCorners(obj: emailTextField)
        updateCorners(obj: passwordTextField)
        updateCorners(obj: loginButton)
        
    }
    
    func updateCorners(obj: UIView){
        obj.layer.cornerRadius = 5
        obj.clipsToBounds = true
    }
    
    
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(signupURL!)
    }
    
    @IBAction func login(_ sender: Any) {
        
        do{
            guard let email =  emailTextField.text, !email.isEmpty else {
                throw InputError.empty(field: "Email")
            }
            
            guard let password =  passwordTextField.text, !password.isEmpty else {
                throw InputError.empty(field: "Password")
            }
            
            ConnectionManager.initilizeConnection(delegate: self, email: email, password: password)
            
        }catch InputError.empty(let field){
            Alert.show(title: "Empty \(field)", message: "Please Enter Your \(field)", sender: self, completion: {
                self.updateActivityIndicator(isHidden: true)
            })
            return
        }catch{
            print("error")
            return
        }
        
        updateActivityIndicator(isHidden: false)
        
        ConnectionManager.login()
    }
    
    func loginSucceeded() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    func serverError(error: String,details: String) {
        DispatchQueue.main.async {
            Alert.show(title: error, message: details, sender: self, completion: {
                self.updateActivityIndicator(isHidden: true)
                return
            })}
    }
    
    func updateActivityIndicator(isHidden: Bool){
        
        if isHidden {
            activityIndicator.stopAnimating()
            return
        }
        
        activityIndicator.startAnimating()
        
    }
    
}
