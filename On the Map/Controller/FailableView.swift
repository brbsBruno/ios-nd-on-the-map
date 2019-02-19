//
//  FailableView.swift
//  On the Map
//
//  Created by Bruno Barbosa on 17/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

protocol FailableView {
    
    func displayFailureAlert(title: String?, error: String)
}

extension FailableView where Self: UIViewController {
    
    func displayFailureAlert(title: String?, error: String) {
        let alertViewController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        
        present(alertViewController, animated: true, completion: nil);
    }
}
