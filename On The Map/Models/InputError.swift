//
//  InputError.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/21/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation

enum InputError: Error{
    case empty(field: String)
    case invalidURL(field: String)
}
