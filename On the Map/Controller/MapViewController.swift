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
    
    // MARK: Properties

    @IBOutlet weak var mapView: MKMapView!
    
    var theData: [StudentInformation]? {
        didSet {
            if (isViewLoaded) {
                reloadAnnotations()
            }
        }
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        setupDataSource()
        setupAnnotations()
    }
    
    //MARK: Setup
    
    func setupDataSource() {
        let tabController = tabBarController as! TabBarController
        theData = tabController.theData
    }
    
    func setupAnnotations() {
        if let studentInformations = theData {
            for student in studentInformations {
                
                if let latitude = student.latitude, let longitude = student.longitude {
                    let annotation = MKPointAnnotation()
                    let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
                    annotation.title = student.fullName
                    annotation.subtitle = student.mediaURL
                    annotation.coordinate = initialLocation.coordinate
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    //MARK: Helpers
    
    func center(mapView: MKMapView, location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func reloadAnnotations() {
        if (mapView.annotations.count > 0) {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        setupAnnotations()
    }
    
    // MARK: Utils
    
    private func displayError(_ error: String) {
        let alertViewController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        
        present(alertViewController, animated: true, completion: nil);
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "StudentInformation"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotationSubtitle = view.annotation?.subtitle,
            let mediaURL = URL(string: annotationSubtitle ?? ""),
            UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            
        } else {
            displayError(NSLocalizedString("Invalid URL", comment: ""))
        }
    }
}
