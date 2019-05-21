//
//  ConnectionManager.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

@objc protocol ConnectionDelegate{
    
    @objc optional func loginSucceeded()
    @objc optional func logoutSucceeded()
    @objc optional func listRetrieved()
    @objc func serverError(error:String, details: String)
    
}

class ConnectionManager {
    
    
    
    static var udacian:Udacian? = nil
    static var connectionDelegate:ConnectionDelegate? = nil
    static var sessionURL = URLComponents()
    static var userURL = URLComponents()
    
    
    
    
    
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
    
    
    
    
    
    static func fireRequest(url:URLComponents, method:String?, headers:[String:String]?, body:Data?, skip: Bool, responseHandler:@escaping (_ data:Data, _ response:URLResponse?, _ error:Error?)->()) {
        
        
        var request = URLRequest(url: url.url!)
        
        request.httpMethod = method ?? "GET"
        
        headers?.forEach{(key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = body
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                self.connectionDelegate?.serverError(error: "Connection Error", details: "Please check your internet connection!")
                return
            }
            
            switch statusCode {
            case 200 ... 299 :
                let newData = skip ? data?.subdata(in: 5..<data!.count) : data
                responseHandler(newData!, response, error)
            case 403:
                self.connectionDelegate?.serverError(error: "Download Failed", details: "Please Refresh!")
            case 400 ... 499:
                self.connectionDelegate?.serverError(error: "Authentication Error", details: "Invalid Username or Password!")
            default :
                self.connectionDelegate?.serverError(error: "Server Error", details: "Something went wrong!")
                
            }
        }
        
        task.resume()
    }
    
    
    static func encode<T:Codable>(object:T) -> Data{
        
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(object)
            return json
        } catch {
            self.connectionDelegate?.serverError(error: "Internal Error", details: "something went wrong while wrapping the data!")
            return "{\"error\": \"something went wrong while encoding\"}".data(using: .utf8)!
        }
    }
    
    
    
    
    static func decode<T: Codable>(data:Data, type:T.Type) -> Codable{
        do {
            let decoder = JSONDecoder()
            let genericObject =  try decoder.decode(type.self, from: data)
            return genericObject
        } catch  {
            print("error while decoding \(type)")
            connectionDelegate?.serverError(error: "Internal Error", details: "Error while unwrapping the data!")
            return Account(registered: false, id: "0")
        }
        
    }
    
    
    static func isValidURL(link: String) -> Bool{
        
        guard link.contains("https://") || link.contains("http://") else {
            return false
        }
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let numberOfMatches = detector.firstMatch(in: link, options: [], range: NSRange(location: 0, length: link.utf16.count))
        
        return numberOfMatches?.range.length == link.utf16.count
        
    }
}






