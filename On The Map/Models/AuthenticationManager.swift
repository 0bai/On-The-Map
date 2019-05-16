//
//  LoginManager.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation


extension ConnectionManager{
    //TODO: FIND A WAY TO SPECIALIZE ERROR MESSAGES
    func login(){
        
        fireRequest(url: sessionURL, method: "POST", headers: ["Accept", "Content-Type"], body: encode(object: udacian), responseHandler: {data,response,error in
            
            self.udacian?.udacity.credentials = self.decode(data: data, type: Credentials.self) as? Credentials
            
            if self.udacian?.udacity.credentials?.session != nil{
                
                OnTheMapAPI.updateUserPath(id: (self.udacian?.udacity.credentials?.account!.id)!)
                self.userURL.path = OnTheMapAPI.userPath
                
                self.getUserData()
                
                
            }else{
                self.connectionDelegate?.serverError(error: "Wrong Username or Password")
            }
        }
        )
    }
    
    func getUserData(){
        self.fireRequest(url: self.userURL, method: nil, headers: nil, body: nil, responseHandler: {data, response, error in
            self.udacian?.udacity.user = (self.decode(data: data, type: User.self) as? User)!
            if self.udacian?.udacity.user?.firstName != nil {
                self.connectionDelegate?.loginSucceeded()
            }
        })
    }
    
    
    func encode<T:Codable>(object:T) -> Data{
        // encoding a JSON body from a string, can also use a Codable struct
        
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(object)
            return json
            
        } catch {
            self.connectionDelegate?.serverError(error: "something went wrong while encoding!")
            return "{\"error\": \"something went wrong while encoding\"}".data(using: .utf8)!
        }
    }
    
    
    func decode<T: Codable>(data:Data, type:T.Type) -> Codable{
        do {
            let decoder = JSONDecoder()
            let genericObject =  try decoder.decode(type.self, from: data)
            return genericObject
        } catch  {
            print("error while decoding \(type)")
            return Account(registered: false, id: "0")
        }
        
    }
    
}









