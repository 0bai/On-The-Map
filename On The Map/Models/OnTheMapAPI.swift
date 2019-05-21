//
//  OnTheMapAPI.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/16/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

class OnTheMapAPI{
    
    static let scheme = "https"
    static let host = "onthemap-api.udacity.com"
    static let version = "/v1"
    static let sessionPath = "\(version)/session"
    static let usersPath = "\(version)/users"
    static let studentLocationsURL = "\(version)/StudentLocation"
    static var userPath = ""
    static var studentsLocation: LocationsList? = nil
    static let queries = ["limit":"100", "order": "-updatedAt"]
    
    static func updateUserPath(id: String){
        userPath = "\(usersPath)/\(id)"
    }
    
    static func clearData(){
        updateUserPath(id: "")
        studentsLocation = nil
    }
}
