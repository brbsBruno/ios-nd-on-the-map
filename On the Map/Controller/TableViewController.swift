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
    
    var theData: StudentInformationModel? {
        didSet {
            if (isViewLoaded) {
                if (theData != nil && theData!.studentInformations.count > 0) {
                    theData!.studentInformations.sort {
                        guard let updatedAt0 = $0.updatedAt, let updatedAt1 = $1.updatedAt else { return false }
                        return updatedAt0 > updatedAt1
                    }
                }
                
                tableView.reloadData()
            }
        }
    }
    
    var loadingView: LoadingView!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView(for: view)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension TableViewController: UITableViewDelegate {
    
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData?.studentInformations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "StudentInformation"
        let cell: UITableViewCell
        
        if let dequeuedView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = dequeuedView
            
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        cell.textLabel?.text = theData?.studentInformations[indexPath.row].fullName
        cell.detailTextLabel?.text = theData?.studentInformations[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = URL(string: theData?.studentInformations[indexPath.row].mediaURL ?? ""), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            
        } else {
            let error = NSLocalizedString("Invalid URL", comment: "")
            displayFailureAlert(title: nil, error: error)
        }
    }
}

extension TableViewController: StudentInformationPresenter {
    
}
