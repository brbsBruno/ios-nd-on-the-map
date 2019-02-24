//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 21/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, FailableView, LoadableView {
    
    // MARK: Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    var loadingView: LoadingView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView(for: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID = "showLocationDetails"
        if segue.identifier == segueID {
            
            if let controller = segue.destination as? LocationDetailsViewController,
                let studentInformation = sender as? StudentInformation {
                controller.studentInformation = studentInformation
            }
        }
    }
    
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
        
        showLoadingView()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            self.dismissLoadingView()
            
            guard let placemark = placemarks?.first,
                let latitude = placemark.location?.coordinate.latitude,
                let longitude = placemark.location?.coordinate.longitude,
                let mapString = placemark.name else {
                    let error = NSLocalizedString("No results found in this location", comment: "")
                    self.displayFailureAlert(title: errorTitle, error: error)
                    return
            }
            
            let firstName: String = UdacityClient.shared().udacityUser!.firstName
            let lastName :String = UdacityClient.shared().udacityUser!.lastName
            let uniqueKey = UdacityClient.shared().udacityUser!.key
            
            let studentInformation = StudentInformation.init(objectId: nil,
                                                             longitude: longitude,
                                                             latitude: latitude,
                                                             mapString: mapString,
                                                             firstName: firstName,
                                                             lastName: lastName,
                                                             mediaURL: website,
                                                             uniqueKey: uniqueKey,
                                                             createdAt: nil,
                                                             updatedAt: nil)
            
            let segueID = "showLocationDetails"
            self.performSegue(withIdentifier: segueID, sender: studentInformation)
        }
    }
}
