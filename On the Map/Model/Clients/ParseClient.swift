//
//  ParseClient.swift
//  On the Map
//
//  Created by Bruno Barbosa on 31/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

class ParseClient {
    
    // MARK: Properties
    
    var session  = URLSession.shared
    
    // MARK: Shared Instance
    
    class func shared() -> ParseClient {
        struct Singleton {
            static var shared = ParseClient()
        }
        return Singleton.shared
    }
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "parse/classes"
    }
    
    // MARK: Methods
    struct Methods {
        
        static let StudentLocation = "StudentLocation"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let Username = "username"
        static let Password = "password"
    }
}

extension ParseClient {
    
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
    
    // MARK: (GET) StudentLocation
    
    func getStudentLocation() -> URLRequest {
        let sessionURL = baseURL(method: Methods.StudentLocation, parameters: nil)
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
}
