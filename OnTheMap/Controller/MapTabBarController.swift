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
    
        print("in refresh data")
        spinner?.show(vc: self)
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
            performUIUpdatesOnMain () {
            
                if success {
                    print("success refresh")
                    studentDataModified = true
                    for vc in self.viewControllers! as [UIViewController] {
                        vc.viewWillAppear(true)
                    }
                    spinner?.hide(vc: self)
                }else{
                    spinner?.hide(vc: self)
                    print(errorString ?? "unknown error ")

                        let alert = UIAlertController(title: nil, message: "Failed download of student locations", preferredStyle: .alert)
                    
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                }
            }
        }
    }
}
