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
    var udacian:Udacian?
    var connectionDelegate:ConnectionDelegate?
    var sessionURL = URLComponents()
    var userURL = URLComponents()
    
    
    init(delegate:ConnectionDelegate, email:String, password:String) {
        
        udacian = Udacian(udacity: Udacity(email: email, password: password))
        
        self.connectionDelegate = delegate
        
        self.sessionURL.scheme = OnTheMapAPI.scheme
        self.sessionURL.host = OnTheMapAPI.host
        self.sessionURL.path = OnTheMapAPI.sessionPath
        
        self.userURL.scheme = OnTheMapAPI.scheme
        self.userURL.host = OnTheMapAPI.host
    }
    
    func fireRequest(url:URLComponents, method:String?, headers:[String]?,body:Data?, responseHandler:@escaping (_ data:Data, _ response:URLResponse?, _ error:Error?)->()){
        
        print(url.url!)
        var request = URLRequest(url: url.url!)
        
        request.httpMethod = method ?? "GET"
        
        headers?.forEach{request.addValue("application/json", forHTTPHeaderField: $0)}
        
        request.httpBody = body
        
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





