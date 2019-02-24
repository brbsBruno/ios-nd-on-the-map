//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Bruno Barbosa on 10/06/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    // MARK: Authentication (GET) Request
    
    func getSession(username: String, password: String, completion: @escaping (_ success: UdacitySession?, _ error: NSError?) -> Void) {
        struct UdacitySessionRequest: Encodable {
            
            let udacity: Udacity
            
            struct Udacity: Encodable {
                var username: String
                var password: String
            }
            
            init(username: String, password: String) {
                let udacity = Udacity(username: username, password: password)
                self.udacity = udacity
            }
        }
        
        let sessionURL = baseURL(method: Methods.Session, parameters: nil)
        let sessionRequest = UdacitySessionRequest(username: username, password: password)
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(sessionRequest)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "getSession", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                let errorMessage = NSLocalizedString("Request failed with error", comment: "")
                sendError(errorMessage)
                return
            }
            
            guard let data = data, data.count > 6 else {
                let errorMessage = NSLocalizedString("Request failed without response data", comment: "")
                sendError(errorMessage)
                return
            }
            
            let range = 5..<data.count
            let validData = data.subdata(in: range)
            
            let unexpectedErrorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                do {
                    struct UdacitySessionResponseError: Decodable {
                        
                        let status: Int
                        let error: String
                    }
                    
                    let responseError = try JSONDecoder().decode(UdacitySessionResponseError.self, from: validData)
                    sendError(responseError.error)
                    
                } catch {
                    sendError(unexpectedErrorMessage)
                }
                
                return
            }
            
            do {
                self.udacitySession = try JSONDecoder().decode(UdacitySession.self, from: validData)
                completion(self.udacitySession, nil)
                
            } catch {
                sendError(unexpectedErrorMessage)
            }
        }
        
        task.resume()
    }
    
    // MARK: (GET) User
    
    func getUser(uniqueKey: String, completionHandler: @escaping (_ success: UdacityUser?, _ error: NSError?) -> Void) {
        var mutableMethod: String = Methods.UsersID
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: uniqueKey)!
        
        let sessionURL = baseURL(method: mutableMethod, parameters: nil)
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "getUser", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                let errorMessage = NSLocalizedString("Request failed with error", comment: "")
                sendError(errorMessage)
                return
            }
            
            guard let data = data, data.count > 6 else {
                let errorMessage = NSLocalizedString("Request failed without response data", comment: "")
                sendError(errorMessage)
                return
            }
            
            let range = 5..<data.count
            let validData = data.subdata(in: range)
            
            let unexpectedErrorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                sendError(unexpectedErrorMessage)
                return
            }
            
            do {
                self.udacityUser = try JSONDecoder().decode(UdacityUser.self, from: validData)
                completionHandler(self.udacityUser, nil)
                
            } catch {
                sendError(unexpectedErrorMessage)
            }
        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
            
        } else {
            return nil
        }
    }
}
