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
    
    func getSession(username: String, password: String) -> URLRequest {
        let sessionURL = baseURL(method: Methods.Session, parameters: nil)
        let sessionRequest = UdacitySessionRequest(username: username, password: password)
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(sessionRequest)
        
        return request
    }
}
