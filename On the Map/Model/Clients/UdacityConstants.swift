//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Bruno Barbosa on 15/07/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "v1"
    }
    
    // MARK: Methods
    
    struct Methods {
        static let Session = "session"
        static let Users = "users"
        static let UsersID = "users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    
    struct ParameterKeys {
        static let Username = "username"
        static let Password = "password"
    }
}
