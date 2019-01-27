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


class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var linkURL: UITextField!
    @IBOutlet weak var addMap: MKMapView!
    
    @IBAction func resignKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
        
        self.location.delegate = self
        self.linkURL.delegate = self
        
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        self.view.endEditing(true)
        return true;
    }
    
    @IBAction func finish(_ sender: Any) {
        
 
        var parameters = [String : AnyObject] ()
        var annotation: MKAnnotation?
        
 //       parameters["uniqueKey"] = "1234" as AnyObject
 //       parameters["firstName"] = userinfo?.FirstName as AnyObject
        parameters["firstName"] = "(Dave)" as AnyObject
        parameters["lastName"] = userinfo?.LastName as AnyObject
        parameters["mapString"] = location.text as AnyObject
//        parameters["mediaURL"] = linkURL.text as AnyObject
        parameters["mediaURL"] = "http://cnn.com" as AnyObject
        annotation = addMap.annotations[0]
        parameters["latitude"] = annotation?.coordinate.latitude as AnyObject
        parameters["longitude"] = annotation?.coordinate.longitude as AnyObject
        
        print (parameters)
        
        ParseClient.sharedInstance().postStudent(studentInfo: parameters)
        ParseClient.sharedInstance().loadPinData() { (success, errorString) in
            if success {
                //                              print("success load pin data")
                performUIUpdatesOnMain () {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                performUIUpdatesOnMain () {
                    let alert = UIAlertController(title: nil, message: "Failed download of student locations", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
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
