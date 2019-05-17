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
    static var userPath = ""
    static var studentsLocation = [StudentInformation]()
    
    static func updateUserPath(id: String){
        userPath = "\(usersPath)/\(id)"
    }
    
    static func clearData(){
        updateUserPath(id: "")
        studentsLocation = [StudentInformation]()
        
    }
}
