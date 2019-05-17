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
    static func login(){
        
        fireRequest(url: sessionURL, method: "POST", headers: ["Accept":"application/json","Content-Type":"application/json"], body: encode(object: udacian), skip: true, responseHandler: {data,response,error in
            
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
    
    static func getUserData(){
        self.fireRequest(url: self.userURL, method: nil, headers: nil, body: nil, skip: true, responseHandler: {data, response, error in
            self.udacian?.udacity.user = (self.decode(data: data, type: User.self) as? User)!
            if self.udacian?.udacity.user?.firstName != nil {
                self.connectionDelegate?.loginSucceeded!()
            }
        }, cookie: { return nil })
    }
    
    static func logout(){
        
        fireRequest(url: sessionURL, method: "DELETE", headers: nil, body: nil, skip: true, responseHandler: {_,_,_ in
            OnTheMapAPI.clearData()
            self.udacian = nil
            self.connectionDelegate?.logoutSucceeded!()
            self.connectionDelegate = nil
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
    
}











