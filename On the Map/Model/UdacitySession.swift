//
//  UdacitySession.swift
//  On the Map
//
//  Created by Bruno Barbosa on 11/08/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import Foundation

struct UdacitySession: Decodable {
    
    let account: Account
    let session: Session
    
    struct Account: Decodable {
        let registered: Bool
        let key: String
    }
    
    struct Session: Decodable {
        let id: String
        let expiration: String
    }
    
}
