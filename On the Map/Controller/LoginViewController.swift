//
//  ViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 08/04/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoadableView, FailableView {
    
    // MARK: Properties
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpTextView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    
    var loadingView: LoadingView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView(for: view)
        
        setupTextFields()
        setupSignUpTextView()
    }
    
    // MARK: Setup
    
    private func setupTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.text = ""
        passwordField.text = ""
    }
    
    private func setupSignUpTextView() {
        let signUpAddress = "https://www.udacity.com/account/auth#!/signup"
        
        let signUpDescription = NSAttributedString(string: NSLocalizedString("Don't have an account?", comment: ""))
        let signUpLink = NSAttributedString(string: NSLocalizedString("Sign Up", comment: ""), attributes:[NSAttributedString.Key.link: URL(string: signUpAddress)!])
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(signUpDescription)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(signUpLink)
        
        signUpTextView.attributedText = attributedText
        signUpTextView.textAlignment = .center
        signUpTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func setupBeginLoginUI() {
        view.endEditing(true)
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        showLoadingView()
    }
    
    private func setupEndLoginUI() {
        dismissLoadingView()
        
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: UIButton) {
        login()
    }
    
    private func login() {
        if let userEmail = emailField.text, let userPassword = passwordField.text {
            guard !userEmail.isEmpty && !userPassword.isEmpty else {
                let title = NSLocalizedString("Login Error", comment: "")
                let error = NSLocalizedString("The Email or the Password cannot be empty", comment: "")
                displayFailureAlert(title: title, error: error)
                
                return
            }
            
            getUdacitySession(username: userEmail, password: userPassword)
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        
        } else if textField == passwordField {
            textField.resignFirstResponder()
            
            login()
        }
        
        return true
    }
}

// MARK: - Networking

extension LoginViewController {
    
    func getUdacitySession(username: String, password: String) {
        setupBeginLoginUI()
        
        let udacityClient = UdacityClient.shared()
        let request = udacityClient.getSession(username: username, password: password)
        
        let task = udacityClient.session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let errorPrefix = NSLocalizedString("Request failed with error", comment: "")
                self.loginFailed(withErrorMessage: errorPrefix)
                return
            }
            
            guard let data = data, data.count > 6 else {
                let errorPrefix = NSLocalizedString("Request failed without response data", comment: "")
                self.loginFailed(withErrorMessage: errorPrefix)
                return
            }
            
            let range = 5..<data.count
            let validData = data.subdata(in: range)
            
            let unexpectedErrorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                do {
                    let responseError = try JSONDecoder().decode(UdacitySessionResponseError.self, from: validData)
                    self.loginFailed(withErrorMessage: responseError.error)
                    
                } catch {
                    print(error)
                    self.loginFailed(withErrorMessage: unexpectedErrorMessage)
                }
                
                return
            }
            
            do {
                let userSession = try JSONDecoder().decode(UdacitySessionResponse.self, from: validData)
                self.loginSucceed(withSessionResponde: userSession)
                
            } catch {
                print(error)
                self.loginFailed(withErrorMessage: unexpectedErrorMessage)
            }
        }
        
        task.resume()
    }
    
    func loginFailed(withErrorMessage message: String) {
        DispatchQueue.main.async {
            self.setupEndLoginUI()
            
            let title = NSLocalizedString("Login Error", comment: "")
            self.displayFailureAlert(title: title, error: message)
        }
    }
    
    func loginSucceed(withSessionResponde userSession: UdacitySessionResponse) {
        DispatchQueue.main.async {
            let userDefaults = UserDefaults.standard
            let udacitySession = UdacitySession.init(sessionRespose: userSession)
            let encodedUserSession: Data = NSKeyedArchiver.archivedData(withRootObject: udacitySession)
            userDefaults.setValue(encodedUserSession, forKeyPath: "userSession")
            userDefaults.synchronize()
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: {
                self.setupEndLoginUI()
                self.setupTextFields()
            })
        }
    }
}
