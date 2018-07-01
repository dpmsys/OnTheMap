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

struct UserInfo {
    var FirstName: String = ""
    var LastName: String = ""
    var emailAddress: String = ""
}

struct MapPin {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: URL
    let objectId: String
    let uniqueKey: String
    let updatedAt: Date
}

var MapPins: [[String:Any]]!



