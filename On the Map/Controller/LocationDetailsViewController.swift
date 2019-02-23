//
//  LocationDetailsViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 21/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var placemark: CLPlacemark?
    
    // UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if let placemark = placemark,
            let coordinate = placemark.location?.coordinate {
            
            addMapAnnotation(title: placemark.name ?? "User's Location", coordinate: coordinate)
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
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
}
