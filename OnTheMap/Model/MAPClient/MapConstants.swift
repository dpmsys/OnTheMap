//
//  MapConstants.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

extension MAPClient {

    struct Constants {
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let AuthHost = "www.udacity.com"
        static let APIPath = ""
    }

    struct Methods {
        static let Users = "/api/users"
        static let Session = "/api/session"
        static let StudentLocation = "/parse/classes/StudentLocation"
    }

    struct ParameterKeys {
        static let ObjectID = "objectdId"
        static let APIKey = "apikey"
    }
    
    struct JSONBodyKeys {
        
    }

    struct JSONResponseKeys {
        static let Account = "account"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionID = "id"
        static let StudentCreated = "createdAt"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectID = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentUpdated = "updatedAt"
    }
}

