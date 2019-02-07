//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/3/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    func getStudentLocation(studentInfo: [String:AnyObject], _ completionHandlerForGetStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject] ()
        var whereclause = String()
        
        whereclause = String(format: "%@%@%@","{\"firstName\":\"",studentInfo[ParseClient.JSONResponseKeys.StudentFirstName] as! String,"\",")
        whereclause += String(format: "%@%@%@", "\"lastName\":\"",studentInfo[ParseClient.JSONResponseKeys.StudentLastName] as! String,"\"}")
        print (whereclause)
//        whereclause = whereclause.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
 //       print (whereclause)
        parameters[ParseClient.ParameterKeys.sqlwhere] = whereclause as AnyObject
        
        let urlstr: String = ParseClient.Methods.StudentLocation
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if let error = error {
                print (error)
                completionHandlerForGetStudent(false, "Get PinData fail (GET session)")
            } else {
                //                print(userinfo?.FirstName)
                //               print(userinfo?.LastName)
                //               print(userinfo?.emailAddress)
                
                if let student = results?[ParseClient.JSONResponseKeys.Results] as! [Dictionary<String, Any>]? {
                    
                    print(results!)
                    print("student")
                    print(student)
                    print("student")
                    if student.count != 0 {
                        studentLocation = StudentInformation(userdict: student[0])
                    }else{
                        studentLocation = StudentInformation(userdict: [ : ])
                    }
                    completionHandlerForGetStudent(true, nil)
                } else {
                    print ("Could not find student data in response")
                    completionHandlerForGetStudent(false, "PinData fail (GET Session)")
                }
            }
        }
    }


    func getStudentLocations(_ completionHandlerForPinData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject] ()
        parameters[ParseClient.ParameterKeys.limit] = "100" as AnyObject
        parameters[ParseClient.ParameterKeys.order] = "-updatedAt" as AnyObject
        
        let urlstr: String = ParseClient.Methods.StudentLocation
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if let error = error {
                print (error)
                completionHandlerForPinData(false, "Get PinData fail (GET session)")
            } else {

                if let studentsDict = results?[ParseClient.JSONResponseKeys.Results] as! [Dictionary<String, Any>]? {
                    print("loading students array")
                    Students.removeAll()
                    for student in studentsDict {
                        Students.append(StudentInformation(userdict: student))
                    }
                    studentDataModified = true
                    completionHandlerForPinData(true, nil)
                } else {
                    print ("Could not find student data in response")
                    completionHandlerForPinData(false, "PinData fail (GET Session)")
                }
            }
        }
    }
    

    
    func postStudent(studentInfo: [String:AnyObject], _ completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        print ("posting student")
        var jsonBody = buildStudentJSONBody(studentInfo: studentInfo)
        
        print(jsonBody)
        
        let _ = taskForPOSTMethod(ParseClient.Methods.StudentLocation, parameters: studentInfo, jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForPostStudent(false, error.localizedDescription)
 //               print (error)
            } else {
//                print("results")
 //               print(results)
//                print("results")
                completionHandlerForPostStudent(true, nil)
           
            }
        }
    }
    
    func putStudent(studentInfo: [String:AnyObject], _ completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        print ("putting student")
        let jsonBody = buildStudentJSONBody(studentInfo: studentInfo)
        print(jsonBody)
        
        let _ = taskForPUTMethod(ParseClient.Methods.StudentLocation, parameters: studentInfo, jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForPostStudent(false, error.localizedDescription)
                //               print (error)
            } else {
                //                print("results")
                //               print(results)
                //                print("results")
                completionHandlerForPostStudent(true, nil)
                
            }
        }
    }
        
    func buildStudentJSONBody (studentInfo: [String:AnyObject]) -> String {
    
        var jsonBody = "{\"\(ParseClient.JSONResponseKeys.StudentUniqueKey)\": \"\(userID ?? "" as String)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLastName)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentLastName] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentFirstName)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentFirstName] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentMapString)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentMapString] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentMediaURL)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentMediaURL] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLatitude)\": \(studentInfo[ParseClient.JSONResponseKeys.StudentLatitude] ?? "" as AnyObject), "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLongitude)\": \(studentInfo[ParseClient.JSONResponseKeys.StudentLongitude] ?? "" as AnyObject)}"
        
        return jsonBody
        
    }
}
