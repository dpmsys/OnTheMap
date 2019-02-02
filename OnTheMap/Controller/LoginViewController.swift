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
        UIApplication.shared.open(URL(string : "https://auth.udacity.com/sign-up")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (status) in
        })
    }
    
    @IBAction func login(_ sender: Any) {
        
        spinner?.show(vc: self)
        UdacityClient.sharedInstance().getAccountSessionID(username: email.text!, password: password.text!) { (success, user, errorString) in
            if success {
               print ("userkey = \(user!)")
                userID = user!
                UdacityClient.sharedInstance().getPublicUserData(user!) { (success, errorString) in
                    if success {
                        spinner?.hide(vc: self)
                        if success {
  //                          ParseClient.sharedInstance().loadPinData() { (success, errorString) in
  //                              if success {
                                    performUIUpdatesOnMain () {
                                        self.performSegue(withIdentifier: "navSegue", sender: self)
                                    }
  //                              }else{
  //                                  self.errorAlert(message: "Failed download of student locations")
   //                             }
  //                          }
                        }else{
                            self.errorAlert(message: "getpublicuserdata failed")
                        }

                    }else{
                        self.errorAlert(message: "getpublicuserdata failed")
                    }
                }
            } else {
                print ("error 2")
                self.errorAlert(message: errorString!)
            }
        }
    }
    
//    func activityIndicator(run: Bool) {
        
 //       performUIUpdatesOnMain () {
 //           if (run) {
//                self.addChild(spinner!)
 //               spinner!.view.frame = self.view.frame
//                self.view.addSubview(spinner!.view)
 //               spinner!.didMove(toParent: self)
                
//            }else{
                
 //               spinner!.willMove(toParent: nil)
//                spinner!.view.removeFromSuperview()
//                spinner!.removeFromParent()

 //           }
 //       }
 //    }
    
    func errorAlert(message: String) {
        
        performUIUpdatesOnMain () {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
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
