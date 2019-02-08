//
//  ViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/24/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = SpinnerViewController()
    }
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: { (status) in
            if (!status) {
                self.errorAlert(message: "Error opening signup URL")
            }
        })
    }
    
    @IBAction func login(_ sender: Any) {
        
        spinner?.show(vc: self)
        UdacityClient.sharedInstance().getAccountSessionID(username: email.text!, password: password.text!) { (success, accountId, errorString) in
            spinner?.hide(vc: self)
            if success {
 //               print ("userkey = \(accountId!)")
                spinner?.show(vc: self)
                UdacityClient.sharedInstance().getPublicUserData(accountId!) { (success, errorString) in
                    spinner?.hide(vc: self)
                    if success {
                        performUIUpdatesOnMain () {
                            self.performSegue(withIdentifier: "navSegue", sender: self)
                        }
                    }else{
                        self.errorAlert(message: (errorString?.description)!)
                    }
                }
            } else {
                self.errorAlert(message: errorString!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
