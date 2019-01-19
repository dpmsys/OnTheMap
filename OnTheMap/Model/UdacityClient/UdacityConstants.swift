//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

extension UdacityClient {

    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "onthemap-api.udacity.com"
        static let APIPath = "/v1"
    }

    struct Methods {
        static let Users = "/users/"
        static let Session = "/session"
    }

    struct ParameterKeys {

    }
    
    struct JSONBodyKeys {
        
    }

    struct JSONResponseKeys {
        static let Account = "account"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionID = "id"
  
        static let User = ""
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
        static let UserEmail = "email"
        static let UserEmailAddr = "address"
    }
}

