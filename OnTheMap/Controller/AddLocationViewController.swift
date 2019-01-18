//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/1/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var linkURL: UITextField!
    @IBOutlet weak var addMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
    }
    
    @IBAction func finish(_ sender: Any) {
        
 
        var parameters = [String : AnyObject] ()
        var annotation: MKAnnotation?
        
        parameters["uniqueKey"] = "1234" as AnyObject
        parameters["firstName"] = userinfo?.FirstName as AnyObject
        parameters["lastName"] = userinfo?.LastName as AnyObject
        parameters["mapString"] = location.text as AnyObject
        parameters["mediaURL"] = linkURL.text as AnyObject
        annotation = addMap.annotations[0]
        parameters["latitude"] = annotation?.coordinate.latitude as AnyObject
        parameters["longitude"] = annotation?.coordinate.longitude as AnyObject
        
        print (parameters)
//      ParseClient.sharedInstance().taskForPOSTMethod(ParseClient.Methods.StudentLocation, parameters: parameters, jsonBody: <#T##String#>, completionHandlerForPOST: <#T##(AnyObject?, NSError?) -> Void#>)
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        print ("geocoding New York, NY", location.text as Any)
        if location.text == "" {
            location.text = "New York, NY"
        }
        
        geocoder.geocodeAddressString(location.text ?? "New York, NY", completionHandler: {(placeMarks, error)->Void in
            
            var loc: CLLocation?
            var coordinate: CLLocationCoordinate2D

            if let error = error {
                print (error)
            }
            
            if let placeMarks = placeMarks, placeMarks.count > 0 {
                loc = placeMarks.first?.location
            
                if let loc = loc {
                    coordinate = loc.coordinate
                    print ("I'm here", coordinate.latitude,coordinate.longitude)
                    let newMark = MKPointAnnotation()

                    newMark.title = self.linkURL.text
                    newMark.coordinate = coordinate
                    
                    self.addMap.addAnnotation(newMark)
                    self.addMap.isHidden = false
                }
            }
        })
    }
}
