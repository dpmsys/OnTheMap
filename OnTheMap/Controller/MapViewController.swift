//
//  MapViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/25/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import UIKit
import MapKit

class MapViewController:  UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner?.show(vc: self)
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
            performUIUpdatesOnMain () {
                if success {
                    self.refreshPins()
                }else{
                    self.errorAlert(message: "Failed download of student locations")
                }
                spinner?.hide(vc: self)
            }
        }

        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        refreshPins()
    }
    
    // MapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView: MKPinAnnotationView!
        let reuseId = "pin"
        
        pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId, for: annotation) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }else{
            pinView!.canShowCallout = true
            pinView!.annotation = annotation
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string:toOpen)!,options: [ : ], completionHandler: { (success) in
                    if (!success) {
                        self.errorAlert(message: "Invalid URL: \(toOpen)")
                    }
                })
            }
        }
    }
    
    
    func refreshPins() {
        
        self.mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        for student in Students.sharedInstance.studentArray {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)

        }
        self.mapView.addAnnotations(annotations)

    }
}

