//
//  Udacian.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

struct Session:Codable {
    var id:String
    var expiration:String
}
struct Account:Codable {
    var registered:Bool
    var id:String
    
    enum CodingKeys: String, CodingKey{
        case id = "key"
        case registered
    }
}

struct Credentials: Codable {
    var session:Session?
    var account:Account?
}

struct Udacity : Codable{
    
    var firstName:String?
    var lastName:String?
    var email:String
    var password:String
    var credentials: Credentials?
    
    enum CodingKeys: String, CodingKey{

        case firstName
        case lastName
        case email = "username"
        case password
        case credentials
    }
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
    
    
    
}

struct Udacian:Codable {
    var udacity:Udacity
}

