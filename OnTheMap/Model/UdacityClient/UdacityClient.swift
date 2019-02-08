//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//
// Class for handling HTTP methods for Udacity REST API

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
                      completionHandlerForGET("Failed GET method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in get", code: 1 , userInfo: nil))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGET("Failed POST method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                return
            }
            
            guard let data = data else {
                completionHandlerForGET("Failed POST method" as AnyObject, NSError(domain: "No data returned by POST", code: 1 , userInfo: nil))
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)            
        }
        
        task.resume()
    
        return task
    }
    
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
    
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            guard (error == nil) else {
                completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in post", code: 1 , userInfo: nil))
                return
            }
            
            guard let statusCode=(response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                switch (response as? HTTPURLResponse)?.statusCode {
                    case 403:
                        completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: "Login failed invalid userid/password", code: 1 , userInfo: nil))
                        return
                    
                    default:
                
                        completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                        return
                }
            }
            
            guard let data = data else {
                completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: "No data returned by POST", code: 1 , userInfo: nil))
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
    
        task.resume()
    
        return task
    }
    
    
    func taskForDELETEMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        var xsrfCookie: HTTPCookie? = nil
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "DELETE"
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForDELETE("Failed POST method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in post", code: 1 , userInfo: nil))
                return
            }

            guard let statusCode=(response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                completionHandlerForDELETE("Failed DELETE method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                return
               
            }
            
            guard let data = data else {
                completionHandlerForDELETE("Failed POST method" as AnyObject, NSError(domain: "No data returned by DELETE", code: 1 , userInfo: nil))
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)

        }
        
        task.resume()
        
        return task
    }
    
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        let range = 5..<data.count
        let newData = data.subdata(in: range)
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
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

        return components.url!
    }

    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}


