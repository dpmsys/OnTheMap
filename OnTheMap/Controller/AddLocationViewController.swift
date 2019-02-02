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
        let _ = sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
        print ("addlocation loaded")
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
        
        if location.text == "" {
            location.text = "New York, NY"
        }
        if linkURL.text == "" {
            linkURL.text = "http://cnn.com"
        }
        
        parameters["uniqueKey"] = sessionID as AnyObject
        parameters["firstName"] = userinfo?.FirstName as AnyObject
//        parameters["firstName"] = "(Dave)" as AnyObject
        parameters["lastName"] = userinfo?.LastName as AnyObject
        parameters["mapString"] = location.text as AnyObject
        parameters["mediaURL"] = linkURL.text as AnyObject
        parameters["mediaURL"] = "http://cnn.com" as AnyObject
        annotation = addMap.annotations[0]
        parameters["latitude"] = annotation?.coordinate.latitude as AnyObject
        parameters["longitude"] = annotation?.coordinate.longitude as AnyObject
        
        print (parameters)
        spinner!.show(vc: self)
        ParseClient.sharedInstance().postStudent(studentInfo: parameters) {(success, errorstring) in
            if success {
                ParseClient.sharedInstance().loadPinData() { (success, errorString) in
                    
                    spinner!.hide(vc: self)
                    if success {
                         performUIUpdatesOnMain () {
                            //                (self.parent as! MapViewController).refreshPins()
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
            }else{
                performUIUpdatesOnMain () {
                    let alert = UIAlertController(title: nil, message: errorstring, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        
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
                    newMark.subtitle = self.linkURL.text
 
                    self.addMap.addAnnotation(newMark)
                    self.addMap.isHidden = false
                }
            }
        })
    }
}
