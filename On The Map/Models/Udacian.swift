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

struct User : Codable{
    
    var firstName:String?
    var lastName:String?
    
    enum CodingKeys: String, CodingKey{
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}

struct Udacity : Codable{
    var email:String
    var password:String
    var credentials: Credentials?
    var user:User?
    
    enum CodingKeys: String, CodingKey{
        case email = "username"
        case password
        case credentials
        case user
    }
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
}

struct Udacian:Codable {
    var udacity:Udacity
}


