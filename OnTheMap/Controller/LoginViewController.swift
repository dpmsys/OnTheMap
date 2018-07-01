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
        
        var request = URLRequest(url: URL(string:"https:/www.udacity.com/api/session")!)

        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let loginID = self.email.text, let loginPassword = self.password.text {
//            request.httpBody = "{\"udacity\":{\"username\":\"\(loginID)\",\"password\":\"\(loginPassword)\"}}".data(using:.utf8)
            request.httpBody = "{\"udacity\":{\"username\":\"mulv2000@gmail.com\",\"password\":\"K1ssB4uG0\"}}".data(using:.utf8)
//        }

        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response,error in
        
            if error != nil { //handle error ....
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)  /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                if let account = parsedResult["account"] as? NSDictionary,let sessionid = parsedResult["session"] as? NSDictionary {
                    userID = account["key"] as? String
  //                  print(sessionid["id"]!)
                    sessionID = sessionid["id"] as? String
                    
                    self.getPublicUserData()
                    self.loadPinData()
                    self.performSegue(withIdentifier: "navSegue", sender: self)
                }
            } catch {
                // TODO: What if I failed?
            }
        }
        task.resume()
    }
    
    
    func getPublicUserData () {
        
        var urlstr: String = "https:/www.udacity.com/api/users/"
        urlstr.append((userID)!)
        let request = NSMutableURLRequest(url: URL(string: urlstr)!)
        
    
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            var parsedResult: NSDictionary
           
            
            if error != nil {
                // handle error
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
       //     print(String(data: newData!, encoding: .utf8)!)
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                if let userDict = parsedResult["user"] as? NSDictionary {
                    if let emailDict = userDict["email"] as? NSDictionary {
                        
                        let userinfo = UserInfo(FirstName: userDict["first_name"] as! String,LastName: userDict["last_name"] as! String,emailAddress: emailDict["address"] as! String)
                        
                        print(userinfo.FirstName)
                        print(userinfo.LastName)
                        print(userinfo.emailAddress)

                    }
                    
                }
            } catch {
                print("serialize failed")
            }
            
        }
        task.resume()
        return
    }
    
    func loadPinData() {
        
        let urlstr: String = "https:/parse.udacity.com/parse/classes/StudentLocation?order=updateAt&limit=100"
        let request = NSMutableURLRequest(url: URL(string: urlstr)!)
        request.addValue(MAPClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(MAPClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            var parsedResult: NSDictionary
            
            if error != nil {
                // handle error
                return
            }
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                if let  pins = parsedResult["results"] as! [NSDictionary]? {
                    MapPins = pins as! [[String:Any]]
                }
            } catch {
                print("serialize failed")
            }
        }
        
        task.resume()
        return

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

