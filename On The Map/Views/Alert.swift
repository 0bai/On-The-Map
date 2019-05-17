//
//  Alert.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/17/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import Foundation
import UIKit

class Alert{
    public static func show(title:String, message: String, sender: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
}
