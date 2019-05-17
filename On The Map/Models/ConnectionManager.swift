//
//  ConnectionManager.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation
@objc protocol ConnectionDelegate{
    @objc func loginSucceeded()
    @objc func logoutSucceeded()
    @objc func serverError(error:String)
}

class ConnectionManager {
    
    static var udacian:Udacian? = nil
    static var connectionDelegate:ConnectionDelegate? = nil
    static var sessionURL = URLComponents()
    static var userURL = URLComponents()
    
    
    private init() {
        

    }
    
    static func initilizeConnection(delegate:ConnectionDelegate, email:String, password:String){
        
        udacian = Udacian(udacity: Udacity(email: email, password: password))
        
        
        self.sessionURL.scheme = OnTheMapAPI.scheme
        self.sessionURL.host = OnTheMapAPI.host
        self.sessionURL.path = OnTheMapAPI.sessionPath
        
        self.userURL.scheme = OnTheMapAPI.scheme
        self.userURL.host = OnTheMapAPI.host
        
        self.updateDelegate(delegate: delegate)
        
    }
    
    static func updateDelegate(delegate:ConnectionDelegate){
        self.connectionDelegate = delegate
    }
    
    
    
    static func fireRequest(url:URLComponents, method:String?, headers:[String:[String]]?,body:Data?, responseHandler:@escaping (_ data:Data, _ response:URLResponse?, _ error:Error?)->(), cookie: @escaping ()->HTTPCookie?){
        
        print(url.url!)
        var request = URLRequest(url: url.url!)
        
        request.httpMethod = method ?? "GET"
        
        headers?.forEach{(arg) in
            
            let (key, value) = arg
            value.forEach{request.addValue(key, forHTTPHeaderField: $0)}
           }
        
        request.httpBody = body 
        
        let coockieToDelete = cookie()
        
        if let xsrfCookie = coockieToDelete {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil{
                self.connectionDelegate?.serverError(error: "something went wrong!")
                return
            }
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            responseHandler(newData!, response, error)
        }
        task.resume()
    }
}





