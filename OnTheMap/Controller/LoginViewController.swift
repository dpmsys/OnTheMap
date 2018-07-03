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
        UIApplication.shared.open(URL(string : "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: { (status) in
        })
    }
    
    @IBAction func login(_ sender: Any) {
        
 //       var request = URLRequest(url: URL(string:"https:/www.udacity.com/api/session")!)

        
//        request.httpMethod = "POST"
   //     request.addValue("application/json", forHTTPHeaderField: "Accept")
  //      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let loginID = self.email.text, let loginPassword = self.password.text {
//            request.httpBody = "{\"udacity\":{\"username\":\"\(loginID)\",\"password\":\"\(loginPassword)\"}}".data(using:.utf8)
 //           request.httpBody = "{\"udacity\":{\"username\":\"mulv2000@gmail.com\",\"password\":\"K1ssB4uG0\"}}".data(using:.utf8)
//        }

//        let session = URLSession.shared
//        let task = session.dataTask(with: request) {data, response,error in
        
 //           if error != nil { //handle error ....
//return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range)  /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
  //          do {
 //               let parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
//                if let account = parsedResult["account"] as? NSDictionary,let sessionid = parsedResult["session"] as? NSDictionary {
//                    userID = account["key"] as? String
  //                  print(sessionid["id"]!)
//                    sessionID = sessionid["id"] as? String
        MAPClient.sharedInstance().getAccountSessionID(username: email.text!, password: password.text!) { (success, user, errorString) in
            if success {
                print ("userkey = \(user!)")
           //     MAPClient.sharedInstance().getPublicUserData()
            }
        }
        
                    
             //       getPublicUserData()
              //      loadPinData()
              //      self.performSegue(withIdentifier: "navSegue", sender: self)

  //      }
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
