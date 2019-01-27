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
//                print(userinfo?.FirstName)
 //               print(userinfo?.LastName)
 //               print(userinfo?.emailAddress)

                if let studentsDict = results?[ParseClient.JSONResponseKeys.Results] as! [Dictionary<String, Any>]? {
print("reloading students array")
                    Students.removeAll()
                    for student in studentsDict {
                        Students.append(StudentInformation(userdict: student))
                    }
                    completionHandlerForPinData(true, nil)
                } else {
                    print ("Could not find student data in response")
                    completionHandlerForPinData(false, "PinData fail (GET Session)")
                }
            }
        }
    }
    
    
    func postStudent(studentInfo: [String:AnyObject]) {
        
        var jsonBody = "{\"\(ParseClient.JSONResponseKeys.StudentUniqueKey)\": \"\(userID ?? "" as String)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLastName)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentLastName] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentFirstName)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentFirstName] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentMapString)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentMapString] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentMediaURL)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentMediaURL] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLatitude)\": \(studentInfo[ParseClient.JSONResponseKeys.StudentLatitude] ?? "" as AnyObject), "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLongitude)\": \(studentInfo[ParseClient.JSONResponseKeys.StudentLongitude] ?? "" as AnyObject)}"
        
        print(jsonBody)
        
        let _ = taskForPOSTMethod(ParseClient.Methods.StudentLocation, parameters: studentInfo, jsonBody: jsonBody) { (results, error) in
            if let error = error {
                print (error)                
            } else {
                print(results)
            }
        }
        
    }
}
