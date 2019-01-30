//
//  MapViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 30/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: -25.1475906, longitude: -50.3493769)
        let regionRadius: CLLocationDistance = 100000
        center(mapView: mapView, location: initialLocation, radius: regionRadius)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Hello World"
        annotation.coordinate = initialLocation.coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    func center(mapView: MKMapView, location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
