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
        }, cookie: { return nil })
    }
    
    func getUserData(){
        self.fireRequest(url: self.userURL, method: nil, headers: nil, body: nil, responseHandler: {data, response, error in
            self.udacian?.udacity.user = (self.decode(data: data, type: User.self) as? User)!
            if self.udacian?.udacity.user?.firstName != nil {
                self.connectionDelegate?.loginSucceeded()
            }
        }, cookie: { return nil })
    }
    
    func logout(){
        
        fireRequest(url: sessionURL, method: "DELETE", headers: nil, body: nil, responseHandler: {_,_,_ in
            OnTheMapAPI.updateUserPath(id: "")
            self.connectionDelegate?.logoutSucceeded()
        },
            cookie: {
            
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            
            return xsrfCookie
            
        }
        )
        
    }
    
    
    func encode<T:Codable>(object:T) -> Data{
        
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











