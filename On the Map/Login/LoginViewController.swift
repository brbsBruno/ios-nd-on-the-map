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
    
    var container: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        setupSignUpTextView()
        setupActivityIndicator()
    }
    
    // MARK: Setup
    
    private func setupSignUpTextView() {
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
    
    private func setupActivityIndicator() {
        container = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = view.center
        
        activityIndicator.hidesWhenStopped = true
        
        container.addSubview(activityIndicator)
    }
    
    private func setupBeginLoginUI() {
        view.endEditing(true)
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        startIndicatingActivity()
    }
    
    private func setupEndLoginUI() {
        stopIndicatingActivity()
        
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }
    
    // MARK: - Acitivity Indicator
    
    func startIndicatingActivity() {
        view.addSubview(self.container)
        activityIndicator.startAnimating()
    }
    
    func stopIndicatingActivity() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: UIButton) {
        login()
    }
    
    private func displayLoginError(_ error: String) {
        let loginErrorTitle = "Login Error"
        let alertViewController = UIAlertController(title: loginErrorTitle, message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertViewController, animated: true, completion: nil);
    }
    
    private func login() {
        if let userEmail = emailField.text, let userPassword = passwordField.text {
            guard !userEmail.isEmpty && !userPassword.isEmpty else {
                displayLoginError("The Email or the Password cannot be empty.")
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
            
            let range = Range(5..<data.count)
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
            
            self.displayLoginError(message)
        }
    }
    
    func loginSucceed(withSessionResponde userSession: UdacitySessionResponse) {
        DispatchQueue.main.async {
            self.setupEndLoginUI()
            
            let userDefaults = UserDefaults.standard
            let udacitySession = UdacitySession.init(sessionRespose: userSession)
            let encodedUserSession: Data = NSKeyedArchiver.archivedData(withRootObject: udacitySession)
            userDefaults.setValue(encodedUserSession, forKeyPath: "userSession")
            userDefaults.synchronize()
        }
    }
}
