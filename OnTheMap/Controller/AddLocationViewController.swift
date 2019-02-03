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


class AddLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var linkURL: UITextField!
    @IBOutlet weak var addMap: MKMapView!
    
    var objectId = String("")
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        addMap.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "addpin")
        
        objectId = ""
        var parameters = [String : AnyObject] ()
        
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
        print ("addlocation loaded")
        self.location.delegate = self
        self.linkURL.delegate = self
        let firstname = (userInfo?.FirstName)! + "(Dave)"
        parameters["firstName"] = firstname as AnyObject
        //        parameters["firstName"] = "(Dave)" as AnyObject
        parameters["lastName"] = userInfo?.LastName as AnyObject

        ParseClient.sharedInstance().getStudentLocation(studentInfo: parameters) {(success, errorString) in
            if success {
                print("get student success")
                print(studentLocation)
                if (studentLocation.objectId != "") {  //pre-existing
                    self.objectId = studentLocation.objectId
                    print(self.objectId)
                    var message = "User \"" + studentLocation.firstName + " " + studentLocation.lastName + "\"has already posted a student location. "
                    message += "Would you like to overwrite their location?"
                    performUIUpdatesOnMain () {
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: nil))
                        let action = UIAlertAction(title: "Cancel", style: .default, handler: self.popView)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }

    
    @IBAction func finish(_ sender: Any) {
        
 
        var parameters = [String : AnyObject] ()
        var annotation: MKAnnotation?
        
 //       if location.text == "" {
  //          location.text = "New York, NY"
  //      }
 //       if linkURL.text == "" {
 //           linkURL.text = "http://cnn.com"
//        }
        
        parameters["uniqueKey"] = sessionID as AnyObject
        let firstname = (userInfo?.FirstName)! + "(Dave)"
        parameters["firstName"] = firstname as AnyObject
//        parameters["firstName"] = "(Dave)" as AnyObject
        parameters["lastName"] = userInfo?.LastName as AnyObject
        parameters["mapString"] = location.text as AnyObject
        parameters["mediaURL"] = linkURL.text as AnyObject
        annotation = addMap.annotations[0]
        parameters["latitude"] = annotation?.coordinate.latitude as AnyObject
        parameters["longitude"] = annotation?.coordinate.longitude as AnyObject
        parameters["objectId"] = studentLocation.objectId as AnyObject
        
        print (parameters)
        
        spinner!.show(vc: self)
        if (studentLocation.objectId == "") {
            ParseClient.sharedInstance().postStudent(studentInfo: parameters) {(success, errorstring) in
                if success {
                    ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
                        
                        spinner!.hide(vc: self)
                        if success {
                             performUIUpdatesOnMain () {
                                //                (self.parent as! MapViewController).refreshPins()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            self.errorAlert(message: "Failed download of student locations")
                       }
                    }
                }else{
                    self.errorAlert(message: errorstring ?? "unknown error")
                }
            }
        }else{
            ParseClient.sharedInstance().putStudent(studentInfo: parameters) {(success, errorstring) in
                if success {
                    ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
                        
                        spinner!.hide(vc: self)
                        if success {
                            performUIUpdatesOnMain () {
                                //                (self.parent as! MapViewController).refreshPins()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            self.errorAlert(message: "Failed download of student locations")
                        }
                    }
                }else{
                    self.errorAlert(message: errorstring ?? "unknown error")
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

                    let region = MKCoordinateRegion(center: coordinate,latitudinalMeters: 10000,longitudinalMeters: 10000)
                    self.addMap.setRegion(region,animated: false)
                    newMark.title = self.linkURL.text
                    newMark.coordinate = coordinate
                    newMark.subtitle = self.linkURL.text
 
                    self.addMap.addAnnotation(newMark)
                    self.addMap.isHidden = false
                    
                    // dismiss the keyboard in case it's still there.
                    self.location.resignFirstResponder( )
                    self.linkURL.resignFirstResponder()
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView: MKPinAnnotationView!
        let reuseId = "addpin"
        
        pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId, for: annotation) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }else{
    //        pinView!.canShowCallout = true
            pinView!.annotation = annotation
 //           pinView!.pinTintColor = .red
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(control)
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            print ("about to open pin URL")
            if let toOpen = view.annotation?.subtitle! {
                print ("opening pin URL")
                app.open(URL(string:toOpen)!,options: [:], completionHandler: nil)
            }
        }
    }
    
    func errorAlert (message: String) {
        performUIUpdatesOnMain () {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func popView(_ action: UIAlertAction) {
        performUIUpdatesOnMain () {
            //                (self.parent as! MapViewController).refreshPins()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
