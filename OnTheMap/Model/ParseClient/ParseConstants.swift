//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/3/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct ParameterKeys {
        static let APIKey = "apikey"
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        static let sqlwhere = "where"
        static let objectid =  "objectid"
    }
    
    struct JSONResponseKeys {
        static let Results = "results"
        static let StudentCreated = "createdAt"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectId = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentUpdated = "updatedAt"
    }
}
