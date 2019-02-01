//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/2/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getAccountSessionID (username: String, password: String, _ completionHandlerForSession: @escaping (_ success: Bool, _ accountID: String?, _ errorString: String?) -> Void) {
        
        let parameters = [String:AnyObject] ()
        let jsonBody: String = "{\"udacity\":{\"username\":\"mulv2000@gmail.com\",\"password\":\"K1ssB4uG0\"}}"
   //     let jsonBody: String = "{\"udacity\":{\"username\":\"\(username)\",\"password\":\"\(password)\"}}"
        
        let _ = taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
        //        print (error)
        //        print ("failed login 1")
                completionHandlerForSession(false, nil, error.domain)
            } else {
                
                if let account = results?[JSONResponseKeys.Account] as? NSDictionary,
                    let session = results?[JSONResponseKeys.Session] as? NSDictionary,
                    let accountID = account[JSONResponseKeys.AccountKey] as? String,
                    let sessionID = session[JSONResponseKeys.SessionID] as? String {
                
                    print("sessionID = \(sessionID)")
                    completionHandlerForSession(true, accountID, nil)
                } else {
                    print ("Could not find account ID in response")
                    completionHandlerForSession(false, nil, "Login fail (Post Session)")
                }
            }
        }
    }
    
    func getPublicUserData (_ userid: String, _ completionHandlerForUserData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        //      var urlstr: String = MAPClient.Constants.APIScheme
        //      urlstr.append("//:")
        //      urlstr.append(MAPClient.Methods.Session)
        
        let parameters = [String:AnyObject] ()
        var urlstr: String = UdacityClient.Methods.Users
        urlstr.append(userid)
        
        //print(urlstr)
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if let error = error {
                print (error)
                completionHandlerForUserData(false, "Get userdata fail (Post session)")
            } else {
                //print(results)
                //?[UdacityClient.JSONResponseKeys.User]
                if let userDict = results as? NSDictionary {
                    if let emailDict = userDict[UdacityClient.JSONResponseKeys.UserEmail] as? NSDictionary {
                        
                        userinfo = UserInfo(FirstName: userDict[UdacityClient.JSONResponseKeys.UserFirstName] as! String,
                                                LastName: userDict[UdacityClient.JSONResponseKeys.UserLastName] as! String,
                                                emailAddress: emailDict[UdacityClient.JSONResponseKeys.UserEmailAddr] as! String)
                        
                        print(userinfo?.FirstName ?? "")
                        print(userinfo?.LastName ?? "")
                        print(userinfo?.emailAddress ?? "")
                        completionHandlerForUserData(true, nil)
                    }
                } else {
                    print ("Could not find account ID in response", results as Any)
                    completionHandlerForUserData(false, "Login fail (Post Session)")
                }
            }
        }
    }
}
