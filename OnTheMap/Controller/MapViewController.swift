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
        
        var pinEntry:Int = 0
        
        for student in Students {

            print(" ")
            print(pinEntry,student.firstName,student.lastName)
//
//            let first = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as? String ?? ""
//            let last = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as? String ?? ""
//            let mediaURL = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as? String ?? ""
//            let latval = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as? Double ?? 0
//            let longval = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as? Double ?? 0
                
//            let lat = CLLocationDegrees(latval)
//            let long = CLLocationDegrees(longval)
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)

 //           print(first,last,mediaURL,lat,long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
          
            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
            pinEntry = pinEntry + 1
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
                app.open(URL(string:toOpen)!,options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([ : ]), completionHandler: nil)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
