//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 21/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, FailableView {
    
    // MARK: Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    // MARK: UIViewController
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        let errorTitle = NSLocalizedString("Add Location Error", comment: "")
        
        guard let location = locationTextField.text, location.count > 0 else {
            let error = NSLocalizedString("Location cannot be empty", comment: "")
            displayFailureAlert(title: errorTitle, error: error)
            return
        }
        
        guard let website = websiteTextField.text, website.count > 0 else {
            let error = NSLocalizedString("Website cannot be empty", comment: "")
            displayFailureAlert(title: errorTitle, error: error)
            return
        }
        
        guard let websiteURL = URL(string: website), UIApplication.shared.canOpenURL(websiteURL) else {
            let error = NSLocalizedString("Website URL is invalid", comment: "")
            displayFailureAlert(title: errorTitle, error: error)
            return
        }
    }
}
