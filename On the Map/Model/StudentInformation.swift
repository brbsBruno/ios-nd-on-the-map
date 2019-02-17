//
//  StudentInformation.swift
//  On the Map
//
//  Created by Bruno Barbosa on 31/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    
    var objectId: String
    var longitude: Double?
    var latitude: Double?
    var mapString: String?
    var firstName: String!
    var lastName: String!
    var mediaURL: String!
    var uniqueKey: String?
    var createdAt: Date
    var updatedAt: Date
    
    var fullName: String {
        return [firstName, lastName].compactMap{ $0 }.joined(separator: " ")
    }
}

struct StudentInformationResults: Codable {
    
    var results: [StudentInformation]?
}
