//
//  TabViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 20/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

protocol StudentInformationPresenter: LoadableView, FailableView {
    // func reloadData()
}

class TabBarController: UITabBarController, FailableView {
    
    // TODO: rename
    var theData: [StudentInformation]?
    
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
    
    func setupMapViewData() {
        let mapViewController = viewControllers?.first as! MapViewController
        mapViewController.theData = theData
    }
    
    func setupTableViewData() {
        let tableViewController = viewControllers?.last as! TableViewController
        tableViewController.theData = theData
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
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        print("add button pressed")
    }
    
    // MARK: Networking
        
    func getStudentsLocation() {
        selectedStudentViewController.showLoadingView()
        
        let parseClient = ParseClient.shared()
        let request = parseClient.getStudentLocation()
        
        let task = parseClient.session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                let errorMessage = NSLocalizedString("Request failed with error", comment: "")
                self.getStudentsLocationFailed(withErrorMessage: errorMessage)
                return
            }
            
            guard let data = data else {
                let errorMessage = NSLocalizedString("Request failed without response data", comment: "")
                self.getStudentsLocationFailed(withErrorMessage: errorMessage)
                return
            }
            
            let errorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                self.getStudentsLocationFailed(withErrorMessage: errorMessage)
                return
            }
            
            let decoder = JSONDecoder()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let studentInformationResults = try? decoder.decode(StudentInformationResults.self, from: data)
            self.getStudentsLocationSucceed(withStudentsInformation: studentInformationResults?.results)
        }
        
        task.resume()
    }
    
    func getStudentsLocationSucceed(withStudentsInformation studentInformation: [StudentInformation]?) {
        DispatchQueue.main.async {
            self.theData = studentInformation
            
            DispatchQueue.main.async {
                self.setupMapViewData()
                self.setupTableViewData()
                self.selectedStudentViewController.dismissLoadingView()
            }
        }
    }
    
    func getStudentsLocationFailed(withErrorMessage message: String) {
        DispatchQueue.main.async {
            self.selectedStudentViewController.dismissLoadingView()
            self.displayFailureAlert(title: nil, error: message)
        }
    }
}
