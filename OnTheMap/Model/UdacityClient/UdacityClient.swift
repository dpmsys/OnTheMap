//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
  
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                print ("Error with GET request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("your GET request returned status other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by GET")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)            
        }
        
        task.resume()
    
        return task
    }
    
    
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
//        var parametersWithAPIKey = parameters
        
//        parametersWithAPIKey[ParameterKeys.APIKey] = Constants.APIKey as AnyObject
    
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
    
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            guard (error == nil) else {
                print (error?.localizedDescription)
                completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unkown error", code: 1 , userInfo: nil))
   //             completionHandlerForPOST("Failed POST method" as AnyObject, error)
                 print("error in request POST method")
                return
            }
            
            guard let statusCode=(response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print((response as? HTTPURLResponse)?.statusCode)
                switch (response as? HTTPURLResponse)?.statusCode {
                    case 403:
                        completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: "Login failed invalid userid/password", code: 1 , userInfo: nil))
                        return
                    
                    default:
                        print("error request returned status other than 2xx!",(response as? HTTPURLResponse)?.statusCode as Any)
                }
                completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: "POST Method", code: 1 , userInfo: nil))
                print("error request returned status other than 2xx!",(response as? HTTPURLResponse)?.statusCode as Any)
                return
            }
            
            guard let data = data else {
                print("error: no data returned by POST")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
    
        task.resume()
    
        return task
    }
    
    func taskForDELETEMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        var xsrfCookie: HTTPCookie? = nil

 //       var request = URLRequest(url: URL(string: method)!)
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            print("session")
            print(xsrfCookie)
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            if error != nil {
                // handle error
                print ("session delete error")
                print (error.debugDescription)
                return
            }
            
            guard let data = data else {
                print("error: no data returned by POST")
                return
            }
            print(data)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        let range = 5..<data.count
        let newData = data.subdata(in: range)
        //print(String(data: newData, encoding: .utf8)!)
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.APIScheme
        components.host = UdacityClient.Constants.APIHost
        components.path = UdacityClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
       // print(components.url!)
        return components.url!
    }

    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}


