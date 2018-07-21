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
}
