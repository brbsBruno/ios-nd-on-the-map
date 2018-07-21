//
//  ViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 08/04/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpTextView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        setupSignUpTextView()
    }
    
    // MARK: Actions
    
    @IBAction func login(_ sender: UIButton) {
        // create a session into Udacity API
        // store the session ID
    }
    
    func setupSignUpTextView() {
        let signUpAddress = "https://www.udacity.com/account/auth#!/signup"
        
        let signUpDescription = NSAttributedString(string: "Don't have an account? ")
        let signUpLink = NSAttributedString(string: "Sign Up", attributes:[NSAttributedStringKey.link: URL(string: signUpAddress)!])
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(signUpDescription)
        attributedText.append(signUpLink)
        
        signUpTextView.attributedText = attributedText
        signUpTextView.textAlignment = .center
        signUpTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        
        } else if textField == passwordField {
            textField.resignFirstResponder()
            
            // TODO: begin login
        }
        
        return true
    }
}
