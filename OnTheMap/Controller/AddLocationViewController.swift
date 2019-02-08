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
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var linkURL: UITextField!
    @IBOutlet weak var addMap: MKMapView!
    
    var objectId = String("")
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        finishButton.isHidden = true
        addMap.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "addpin")
        
        objectId = ""
        var parameters = [String : AnyObject] ()
        
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
        self.location.delegate = self
        self.linkURL.delegate = self
        parameters["firstName"] = userInfo?.FirstName as AnyObject
        parameters["lastName"] = userInfo?.LastName as AnyObject

        ParseClient.sharedInstance().getStudentLocation(studentInfo: parameters) {(success, errorString) in
            if success {
                if (studentLocation.objectId != "") {  //pre-existing
                    self.objectId = studentLocation.objectId
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
        
        parameters["uniqueKey"] = sessionID as AnyObject
        parameters["firstName"] = userInfo?.FirstName as AnyObject
        parameters["lastName"] = userInfo?.LastName as AnyObject
        parameters["mapString"] = location.text as AnyObject
        parameters["mediaURL"] = linkURL.text as AnyObject
        annotation = addMap.annotations[0]
        parameters["latitude"] = annotation?.coordinate.latitude as AnyObject
        parameters["longitude"] = annotation?.coordinate.longitude as AnyObject
        parameters["objectId"] = studentLocation.objectId as AnyObject
        
        spinner!.show(vc: self)
        if (studentLocation.objectId == "") {
            ParseClient.sharedInstance().postStudent(studentInfo: parameters) {(success, errorstring) in
                spinner!.hide(vc: self)
                if success {
                    spinner!.show(vc: self)
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
        
        if !(linkURL.text?.hasPrefix("http://"))! {
            linkURL.text = "http://" + (linkURL.text ?? "")
        }
        
        spinner!.show(vc: self)
        geocoder.geocodeAddressString(location.text!, completionHandler: {(placeMarks, error)->Void in
            
            var loc: CLLocation?
            var coordinate: CLLocationCoordinate2D

            spinner!.hide(vc: self)
            if let error = error {
                print (error)
            }
            
            if let placeMarks = placeMarks, placeMarks.count > 0 {
                loc = placeMarks.first?.location
            
                if let loc = loc {
                    coordinate = loc.coordinate
 
                    let newMark = MKPointAnnotation()

                    let region = MKCoordinateRegion(center: coordinate,latitudinalMeters: 10000,longitudinalMeters: 10000)
                    self.addMap.setRegion(region,animated: false)
                    newMark.title = self.linkURL.text
                    newMark.coordinate = coordinate
                    newMark.subtitle = self.linkURL.text
 
                    self.addMap.addAnnotation(newMark)
                    self.addMap.isHidden = false
                    self.finishButton.isHidden = false
                    
                    // dismiss the keyboard in case it's still there.
                    self.location.resignFirstResponder( )
                    self.linkURL.resignFirstResponder()
                }
                
            }else{
                self.errorAlert(message: "geocoding failed for \(self.location.text ?? " ")")
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
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string:toOpen)!,options: [:], completionHandler: nil)
            }
        }
    }
       
    func popView(_ action: UIAlertAction) {
        performUIUpdatesOnMain () {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
