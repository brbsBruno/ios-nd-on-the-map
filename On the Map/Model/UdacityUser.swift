//
//  UdacityUser.swift
//  On the Map
//
//  Created by Bruno Barbosa on 24/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

struct UdacityUser: Decodable {

    var firstName: String
    var lastName: String
    var key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
    
}
