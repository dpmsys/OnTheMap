//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/3/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation

extension ParseClient {
    
    //
    // get specific student by first and last name lookup to determine if our location is already posted
    //
    
    func getStudentLocation(studentInfo: [String:AnyObject], _ completionHandlerForGetStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject] ()
        var whereclause = String()
        
        whereclause = String(format: "%@%@%@","{\"firstName\":\"",studentInfo[ParseClient.JSONResponseKeys.StudentFirstName] as! String,"\",")
        whereclause += String(format: "%@%@%@", "\"lastName\":\"",studentInfo[ParseClient.JSONResponseKeys.StudentLastName] as! String,"\"}")

        parameters[ParseClient.ParameterKeys.sqlwhere] = whereclause as AnyObject
        
        let urlstr: String = ParseClient.Methods.StudentLocation
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if error != nil {
                completionHandlerForGetStudent(false, "Get student location failed")
            } else {
                if let student = results?[ParseClient.JSONResponseKeys.Results] as! [Dictionary<String, Any>]? {
                    if student.count != 0 {
                        studentLocation = StudentInformation(userdict: student[0])
                    }else{
                        studentLocation = StudentInformation(userdict: [ : ])
                    }
                    completionHandlerForGetStudent(true, nil)
                } else {
                    completionHandlerForGetStudent(false, "Get student location failed")
                }
            }
        }
    }

    //
    // get all stucent locations to show pins on map
    //

    func getStudentLocations(_ completionHandlerForPinData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject] ()
        parameters[ParseClient.ParameterKeys.limit] = "100" as AnyObject
        parameters[ParseClient.ParameterKeys.order] = "-updatedAt" as AnyObject
        
        let urlstr: String = ParseClient.Methods.StudentLocation
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if error != nil {
                completionHandlerForPinData(false, "Get student locations failed")
            } else {

                if let studentsDict = results?[ParseClient.JSONResponseKeys.Results] as! [Dictionary<String, Any>]? {
 
                    Students.sharedInstance.studentArray.removeAll()
                    for student in studentsDict {
                        Students.sharedInstance.studentArray.append(StudentInformation(userdict: student))
                    }
                    studentDataModified = true
                    completionHandlerForPinData(true, nil)
                } else {
                    completionHandlerForPinData(false, "Get student locations failed")
                }
            }
        }
    }
    

    //
    // post new student location information when not previously posted
    //
    func postStudent(studentInfo: [String:AnyObject], _ completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        

        let jsonBody = buildStudentJSONBody(studentInfo: studentInfo)
        
        let _ = taskForPOSTMethod(ParseClient.Methods.StudentLocation, parameters: studentInfo, jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForPostStudent(false, error.localizedDescription)
            } else {
                completionHandlerForPostStudent(true, nil)
            }
        }
    }
    
    //
    // put to update student location information when previously posted.
    //
    func putStudent(studentInfo: [String:AnyObject], _ completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
 
        let jsonBody = buildStudentJSONBody(studentInfo: studentInfo)
        
        let _ = taskForPUTMethod(ParseClient.Methods.StudentLocation, parameters: studentInfo, jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForPostStudent(false, error.localizedDescription)
            } else {
                completionHandlerForPostStudent(true, nil)
            }
        }
    }
    
    //
    // Fill JSON body from studentInfo struct for PUT/POST of student location
    //
    
    func buildStudentJSONBody (studentInfo: [String:AnyObject]) -> String {
    
        var jsonBody = "{\"\(ParseClient.JSONResponseKeys.StudentUniqueKey)\": \"\(accountID ?? "" as String)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLastName)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentLastName] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentFirstName)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentFirstName] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentMapString)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentMapString] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentMediaURL)\": \"\(studentInfo[ParseClient.JSONResponseKeys.StudentMediaURL] ?? "" as AnyObject)\", "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLatitude)\": \(studentInfo[ParseClient.JSONResponseKeys.StudentLatitude] ?? "" as AnyObject), "
        jsonBody = jsonBody + "\"\(ParseClient.JSONResponseKeys.StudentLongitude)\": \(studentInfo[ParseClient.JSONResponseKeys.StudentLongitude] ?? "" as AnyObject)}"
        
        return jsonBody
        
    }
}
