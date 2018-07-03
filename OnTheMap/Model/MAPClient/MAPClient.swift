//
//  MAPClient.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import Foundation

class MAPClient : NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var parametersWithAPIKey = parameters
        
        parametersWithAPIKey[ParameterKeys.APIKey] = Constants.APIKey as AnyObject
    
        let request = NSMutableURLRequest(url: mapURLFromParameters(parametersWithAPIKey, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
    
        let task = session.dataTask(with:  request as URLRequest) {(data, response, error) in
            guard (error == nil) else {
                print("error in request POST method")
                return
            }
            
            guard let statusCode=(response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("error request returned status other than 2xx!")
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
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func mapURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = MAPClient.Constants.APIScheme
        components.host = MAPClient.Constants.AuthHost
        components.path = MAPClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }

    class func sharedInstance() -> MAPClient {
        struct Singleton {
            static var sharedInstance = MAPClient()
        }
        return Singleton.sharedInstance
    }
}


