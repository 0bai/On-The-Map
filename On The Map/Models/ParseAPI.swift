//
//  ParseAPI.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/17/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

struct ParseAPI{
    static let scheme = "https"
    static let host = "parse.udacity.com"
    static let path = "/parse/classes/StudentLocation"
    static let queries = ["limit":"100", "order": "updatedAt"]
}
