//
//  TableViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 30/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var theData: [StudentInformation]? {
        didSet {
            if (isViewLoaded) {
                if (theData != nil) {
                    theData!.sort { $0.updatedAt > $1.updatedAt }
                }
                
                tableView.reloadData()
            }
        }
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupDataSource()
    }
    
    //MARK: Setup
    
    func setupDataSource() {
        let tabController = tabBarController as! TabBarController
        theData = tabController.theData
    }
    
    // MARK: Utils
    
    private func displayError(_ error: String) {
        let alertViewController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        
        present(alertViewController, animated: true, completion: nil);
    }
}

extension TableViewController: UITableViewDelegate {
    
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "StudentInformation"
        let cell: UITableViewCell
        
        if let dequeuedView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = dequeuedView
            
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        cell.textLabel?.text = theData?[indexPath.row].fullName
        cell.detailTextLabel?.text = theData?[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = URL(string: theData?[indexPath.row].mediaURL ?? ""), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            
        } else {
            displayError(NSLocalizedString("Invalid URL", comment: ""))
        }
        
    }
    
}

extension TableViewController: StudentInformationPresenter {
    
}
