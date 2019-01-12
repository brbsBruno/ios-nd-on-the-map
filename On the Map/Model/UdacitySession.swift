//
//  UdacitySession.swift
//  On the Map
//
//  Created by Bruno Barbosa on 11/08/18.
//  Copyright © 2018 Bruno Barbosa. All rights reserved.
//

import Foundation

class UdacitySession: NSObject, NSCoding {
    
    var id: String?
    var expiration: Date
    
    init(id: String, expiration: Date) {
        self.id = id
        self.expiration = expiration
    }
    
    init(sessionRespose: UdacitySessionResponse) {
        self.id = sessionRespose.session.id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        guard let date = dateFormatter.date(from: sessionRespose.session.expiration) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        self.expiration = date
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let expiration = aDecoder.decodeObject(forKey: "expiration") as? Date
            else { return nil }
        
        self.init(id: id, expiration: expiration)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "title")
        aCoder.encode(self.expiration, forKey: "author")
    }
}

struct UdacitySessionResponse: Decodable {
    
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

struct UdacitySessionResponseError: Decodable {
    
    let status: Int
    let error: String
}

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
