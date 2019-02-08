//
//  ParseClient.swift
//  OnTheMap
//
//  Created by David Mulvihill on 7/3/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//
// class for handling HTTP methods for PARSE 

import Foundation
class ParseClient : NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))

        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                completionHandlerForGET("Failed GET method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in get", code: 1 , userInfo: nil))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGET("Failed GET method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                return
            }
            
            guard let data = data else {
                completionHandlerForGET("Failed POST method" as AnyObject, NSError(domain: "No data returned by GET", code: 1 , userInfo: nil))
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)

        
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            guard (error == nil) else {
                completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in post", code: 1 , userInfo: nil))
                return
            }
            
            guard let statusCode=(response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForPOST("Failed POST method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                return
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
    
    func taskForPUTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var method = method
        method += "/" + (parameters[ParseClient.JSONResponseKeys.StudentObjectId] as! String)
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))

        request.httpMethod = "PUT"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            guard (error == nil) else {
                completionHandlerForPUT("Failed PUT method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in PUT", code: 1 , userInfo: nil))
                return
            }
            
            guard let statusCode=(response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForPUT("Failed PUT method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                return
            }
            
            guard let data = data else {
                completionHandlerForPUT("Failed PUT method" as AnyObject, NSError(domain: "No data returned by PUT", code: 1 , userInfo: nil))
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        task.resume()
        
        return task
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.APIScheme
        components.host = ParseClient.Constants.APIHost
        components.path = ParseClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
