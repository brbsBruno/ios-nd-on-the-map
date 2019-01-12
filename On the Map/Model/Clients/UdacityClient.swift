//
//  UdacityClient.swift
//  On the Map
//
//  Created by Bruno Barbosa on 03/06/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    // MARK: Properties
    
    var session  = URLSession.shared
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Shared Instance
    
    class func shared() -> UdacityClient {
        struct Singleton {
            static var shared = UdacityClient()
        }
        return Singleton.shared
    }
    
    // MARK: Utils
    
    func baseURL(method: String, parameters: [String:AnyObject]?) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = "/" + Constants.ApiPath + "/" + method
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
}
