//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/3/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func loadPinData(_ completionHandlerForPinData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject] ()
        parameters[ParseClient.ParameterKeys.limit] = "100" as AnyObject
        
        let urlstr: String = ParseClient.Methods.StudentLocation
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if let error = error {
                print (error)
                completionHandlerForPinData(false, "Get PinData fail (GET session)")
            } else {
                if let  pins = results?[ParseClient.JSONResponseKeys.Results] as! [NSDictionary]? {
                    MapPins = pins as? [[String:Any]]
                    completionHandlerForPinData(true, nil)
                } else {
                    print ("Could not find student data in response")
                    completionHandlerForPinData(false, "PinData fail (GET Session)")
                }
            }
        }
    }
    
    
}
