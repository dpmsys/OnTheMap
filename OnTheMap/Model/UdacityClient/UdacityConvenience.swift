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
    //    let jsonBody: String = "{\"udacity\":{\"username\":\"mulv2000@gmail.com\",\"password\":\"\"}}"
        let jsonBody: String = "{\"udacity\":{\"username\":\"mulv2000@gmail.com\",\"password\":\"\(password)\"}}"
   //     let jsonBody: String = "{\"udacity\":{\"username\":\"\(username)\",\"password\":\"\(password)\"}}"
        
        let _ = taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
                    
            if let error = error {
                completionHandlerForSession(false, nil, error.domain)
            } else {
                if let account = results?[JSONResponseKeys.Account] as? NSDictionary,
                    let session = results?[JSONResponseKeys.Session] as? NSDictionary,
                    let accountID = account[JSONResponseKeys.AccountKey] as? String,
                    let _ = session[JSONResponseKeys.SessionID] as? String {            //sessionID
                
                    completionHandlerForSession(true, accountID, nil)
                } else {
                    completionHandlerForSession(false, nil, "Could not find account ID in response")
                }
            }
        }
    }
    
    func getPublicUserData (_ accountId: String, _ completionHandlerForUserData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let parameters = [String:AnyObject] ()
        var urlstr: String = UdacityClient.Methods.Users
        urlstr.append(accountId)
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if let error = error {
                completionHandlerForUserData(false, "Get userdata fail: \(error.domain)")
            } else {
                print(results)
                print([UdacityClient.JSONResponseKeys.User])
                if let userDict = results as? NSDictionary {
                    if let emailDict = userDict[UdacityClient.JSONResponseKeys.UserEmail] as? NSDictionary {
                        
                        userInfo = UserInfo(FirstName: userDict[UdacityClient.JSONResponseKeys.UserFirstName] as! String,
                                                LastName: userDict[UdacityClient.JSONResponseKeys.UserLastName] as! String,
                                                emailAddress: emailDict[UdacityClient.JSONResponseKeys.UserEmailAddr] as! String)
                        
                        completionHandlerForUserData(true, nil)
                    }
                } else {
                    completionHandlerForUserData(false, "Getuser data fail: no data returned")
                }
            }
        }
    }
    
    func logout (_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForDELETEMethod(UdacityClient.Methods.Session, parameters: [ : ]) { (results, error) in
            
            if let error = error {
                completionHandlerForLogout(false, "Logout failed: \(error.domain)")
            }else{
                if let sessionDict = results?[JSONResponseKeys.Session] as? NSDictionary,
                    let sessionID = sessionDict[JSONResponseKeys.SessionID] as? String,
                    let expiration = sessionDict[JSONResponseKeys.Expiration] as? String {            //sessionID

                    completionHandlerForLogout(true, nil)
                    
                } else {
                    completionHandlerForLogout(false, "Getuser data fail: no data returned")
                }
            }
        }
    }
}
