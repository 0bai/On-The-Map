//
//  MapLocationsManager.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/17/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

extension ConnectionManager{
    
    static func getLocations(){
        
        var locationsURL = URLComponents()
        locationsURL.scheme = OnTheMapAPI.scheme
        locationsURL.host = OnTheMapAPI.host
        locationsURL.path = OnTheMapAPI.studentLocationsURL
        locationsURL.queryItems = []
        OnTheMapAPI.queries.forEach{ key , val in locationsURL.queryItems?.append(URLQueryItem(name: key, value: val))}
        
        let headers = [
            "X-Parse-Application-Id":"QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key":"QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]
        
        fireRequest(url: locationsURL, method: nil, headers: headers, body: nil, skip: false, responseHandler: {data,response,error in
            
            OnTheMapAPI.studentsLocation = self.decode(data: data, type: LocationsList.self) as? LocationsList
            
            self.connectionDelegate?.listRetrieved?()
        })
        
    }
    
    
    static func postLocation(location:StudentInformation){
        var locationsURL = URLComponents()
        locationsURL.scheme = OnTheMapAPI.scheme
        locationsURL.host = OnTheMapAPI.host
        locationsURL.path = OnTheMapAPI.studentLocationsURL
        
        fireRequest(url: locationsURL, method: "POST", headers: ["Content-Type" : "application/json"], body: encode(object: location), skip: false, responseHandler: {data, response, error in
            udacian?.locationID = (self.decode(data: data, type: StudentInformation.self) as? StudentInformation)?.id ?? "nil"
            self.connectionDelegate?.locationPosted?()
        })
        
    }
    
    
}
