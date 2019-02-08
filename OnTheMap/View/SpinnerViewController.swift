//
//  SpinnerViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 2/1/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
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
