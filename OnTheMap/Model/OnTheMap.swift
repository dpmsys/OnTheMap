//
//  OnTheMap.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import MapKit

var sessionID: String? = nil
var userID: String? = nil
var MapPoints: MKPointAnnotation?
var studentDataModified: Bool = false
var spinner: SpinnerViewController?


struct UserInfo {
    var FirstName: String = ""
    var LastName: String = ""
    var emailAddress: String = ""
}

struct StudentInformation {
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    init () {
        self.createdAt = ""
        self.firstName = "[No Firstname]"
        self.lastName = "[No Lastname]"
        self.latitude = 0.0
        self.longitude = 0.0
        self.mapString = ""
        self.mediaURL = ""
        self.objectId = ""
        self.uniqueKey = ""
        self.updatedAt = ""

    }
    
    init (userdict: Dictionary <String,Any?>) {
        self.createdAt = userdict[ParseClient.JSONResponseKeys.StudentCreated] as? String ?? ""
        self.firstName = userdict[ParseClient.JSONResponseKeys.StudentFirstName] as? String ?? "[No Firstname]"
        self.lastName = userdict[ParseClient.JSONResponseKeys.StudentLastName] as? String ?? "[No Lastname]"
        self.latitude = userdict[ParseClient.JSONResponseKeys.StudentLatitude]  as? Double ?? 0
        self.longitude = userdict[ParseClient.JSONResponseKeys.StudentLongitude] as? Double ?? 0
        self.mapString = userdict[ParseClient.JSONResponseKeys.StudentMapString] as? String ?? ""
        self.mediaURL = userdict[ParseClient.JSONResponseKeys.StudentMediaURL] as? String ?? ""
        self.objectId = userdict[ParseClient.JSONResponseKeys.StudentObjectId] as? String ?? ""
        self.uniqueKey = userdict[ParseClient.JSONResponseKeys.StudentUniqueKey] as? String ?? ""
        self.updatedAt = userdict[ParseClient.JSONResponseKeys.StudentUpdated] as? String ?? ""
    }
}
var annotations = [MKPointAnnotation] ()
var studentLocation = StudentInformation()
var Students = [StudentInformation] ()

var MapPins: [[String:Any]]!
var userInfo: UserInfo?



