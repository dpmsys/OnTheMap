//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/30/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation
import UIKit

class MapTabBarController:     UITabBarController {
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.sharedInstance().logout() { (success, errorString) in
            
            if  success {
                print("success")
            }
        }
        self.dismiss(animated: true)
    }
    
    
    @IBAction func refresh(_ sender: Any) {
    
        spinner?.show(vc: self)
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
            performUIUpdatesOnMain () {
            
                if success {
                    studentDataModified = true
                    for vc in self.viewControllers! as [UIViewController] {
                        vc.viewWillAppear(true)
                    }
                    spinner?.hide(vc: self)
                }else{
                    spinner?.hide(vc: self)
                    
                    self.errorAlert(message: "Failed download of student locations")
                }
            }
        }
    }
}
