//
//  LocationDetailsViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 21/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController, LoadableView, FailableView {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentInformation: StudentInformation!
    
    var loadingView: LoadingView!
    
    // UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView(for: view)

        if let studentInformation = studentInformation,
            let latitude = studentInformation.latitude,
            let longitude = studentInformation.longitude,
            let mapString = studentInformation.mapString {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            addMapAnnotation(title: mapString, coordinate: coordinate)
            centerMapOnCoordinate(coordinate: coordinate)
        }
    }
    
    // Setup
    
    func addMapAnnotation(title: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func centerMapOnCoordinate(coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Actions
    
    @IBAction func finish(_ sender: Any) {
        showLoadingView()
        
        ParseClient.shared().postStudentLocation(studentLocation: studentInformation) { (success, error) in
            
            DispatchQueue.main.async {
                self.dismissLoadingView()
                
                if let error = error {
                    self.displayFailureAlert(title: nil, error: error.localizedDescription)
                    
                    
                } else if success == true {
                    self.parent?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
