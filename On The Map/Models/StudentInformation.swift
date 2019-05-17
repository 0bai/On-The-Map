//
//  Location.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

struct StudentInformation : Codable{
    
    var id:String
    var key:String
    var firstName:String
    var lastName:String
    var geocode:String
    var website:String
    var latitude:Float
    var longitude:Float
    
    enum CodingKeys: String, CodingKey{
        case id = "objectId"
        case key = "uniqueKey"
        case firstName
        case lastName
        case geocode = "mapString"
        case website = "mediaURL"
        case latitude
        case longitude
    }
    
    
}

struct LocationsList : Codable {
    var results:[StudentInformation]
}
