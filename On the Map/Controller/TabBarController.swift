//
//  TabViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 20/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

protocol StudentInformationPresenter: LoadableView, FailableView {

}

class TabBarController: UITabBarController, FailableView {
    
    var studentsViewControllers: [StudentInformationPresenter] {
        return self.viewControllers as! [StudentInformationPresenter]
    }
    
    var selectedStudentViewController: StudentInformationPresenter {
        return studentsViewControllers[selectedIndex]
    }
    
    //MARK: UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentsLocation()
    }
    
    //MARK: Setup
    
    func setupMapViewData(with data: [StudentInformation]?) {
        let mapViewController = viewControllers?.first as! MapViewController
        mapViewController.theData = data
    }
    
    func setupTableViewData(with data: [StudentInformation]?) {
        let tableViewController = viewControllers?.last as! TableViewController
        tableViewController.theData = data
        if (tableViewController.isViewLoaded) {
            tableViewController.tableView.reloadData()
        }
    }
    
    //MARK: Actions
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userSession")
        userDefaults.synchronize()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getStudentsLocation()
    }

    // MARK: Networking
        
    func getStudentsLocation() {
        selectedStudentViewController.showLoadingView()
        
        ParseClient.shared().getStudentLocation { (studentInformation, error) in
            
            DispatchQueue.main.async {
                self.selectedStudentViewController.dismissLoadingView()
                
                if let error = error {
                    self.displayFailureAlert(title: nil, error: error.localizedDescription)
                    
                } else {
                    self.setupMapViewData(with: studentInformation)
                    self.setupTableViewData(with: studentInformation)
                }
            }
        }
    }
}
