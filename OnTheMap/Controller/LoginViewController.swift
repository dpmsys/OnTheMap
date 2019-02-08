//
//  ViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/24/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = SpinnerViewController()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
//	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
//}
