//
//  SpinnerViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 2/1/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//
// Code for spinner class found on www.hackingwithswift.com
// https://www.hackingwithswift.com/example-code/uikit/how-to-use-uiactivityindicatorview-to-show-a-spinner-when-work-is-happening
//

import Foundation
import UIKit

//
// view controller for showing activity indicator
//

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
// from apple docs " If you want to use Auto Layout to dynamically calculate the size and position of your view,
// you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view."

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func show(vc: UIViewController) {
        
        performUIUpdatesOnMain () {
            vc.addChild(self)
            self.view.frame = vc.view.frame
            vc.view.addSubview(self.view)
            self.didMove(toParent: vc)
        }
    }
    
    func hide(vc: UIViewController) {
        
        performUIUpdatesOnMain () {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
