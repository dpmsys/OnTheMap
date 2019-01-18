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
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://auth.udacity.com/sign-up")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (status) in
        })
    }
    
    @IBAction func login(_ sender: Any) {
        
        UdacityClient.sharedInstance().getAccountSessionID(username: email.text!, password: password.text!) { (success, user, errorString) in
            if success {
                print ("userkey = \(user!)")
                UdacityClient.sharedInstance().getPublicUserData(user!) { (success, errorString) in
                    if success {
                        print ("success")
                        ParseClient.sharedInstance().loadPinData() { (success, errorString) in
                            if success {
                                print("success load pin data")
                                performUIUpdatesOnMain () {
                                    self.performSegue(withIdentifier: "navSegue", sender: self)
                                }
                            }
                        }
                    }else{
                        print ("getpublicuserdata failed")
                    }
                }
            }
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
