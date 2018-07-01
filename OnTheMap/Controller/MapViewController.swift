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
        

 
        var annotations = [MKPointAnnotation] ()
        
        for dictionary in MapPins {
            
            let lat = CLLocationDegrees(dictionary[MAPClient.JSONResponseKeys.StudentLatitude] as! Double)
            let long = CLLocationDegrees(dictionary[MAPClient.JSONResponseKeys.StudentLongitude] as! Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
            let first = dictionary[MAPClient.JSONResponseKeys.StudentLastName] as! String
            let last = dictionary[MAPClient.JSONResponseKeys.StudentFirstName] as! String
            let mediaURL = dictionary[MAPClient.JSONResponseKeys.StudentMediaURL] as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
        }
    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }else{
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
           //     app.openURL(URL(string: toOpen)!)
                app.open(URL(string:toOpen)!,options: [ : ], completionHandler: nil)
            }
        }
    }
}
