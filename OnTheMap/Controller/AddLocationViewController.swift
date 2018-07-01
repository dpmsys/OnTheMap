//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/1/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation
import UIKit

class AddLocationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performUIUpdatesOnMain {
            self.navigationItem.leftBarButtonItem?.title = "Cancel"
        }
    }
}
