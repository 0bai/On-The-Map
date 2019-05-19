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
        
        var parseURL = URLComponents()
        parseURL.scheme = ParseAPI.scheme
        parseURL.host = ParseAPI.host
        parseURL.path = ParseAPI.path
        parseURL.queryItems = []
        ParseAPI.queries.forEach{ key , val in parseURL.queryItems?.append(URLQueryItem(name: key, value: val))}

        let headers = [
            "X-Parse-Application-Id":"QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key":"QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]
        
        fireRequest(url: parseURL, method: nil, headers: headers, body: nil, skip: false, responseHandler: {data,response,error in
            
            OnTheMapAPI.studentsLocation = self.decode(data: data, type: LocationsList.self) as? LocationsList
            if OnTheMapAPI.studentsLocation != nil {
                self.connectionDelegate?.listRetrieved?()
            }
        }, cookie: {return nil})
        
    }
    
    
    
}
