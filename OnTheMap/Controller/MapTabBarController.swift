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
    
    @IBAction func refresh(_ sender: Any) {
    
        print("in refresh data")
        ParseClient.sharedInstance().loadPinData() { (success, errorString) in
            if success {
                print("success refresh")
 //               performUIUpdatesOnMain () {
  //                  self.performSegue(withIdentifier: "navSegue", sender: self)
 //               }
            }else{
                print(errorString)
  //              performUIUpdatesOnMain () {
  //                  let alert = UIAlertController(title: nil, message: "Failed download of student locations", preferredStyle: .alert)
                    
 //                   alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
 //                   self.present(alert, animated: true)
                }
            }
        
    }
    
}
