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
    
    public static func show(title:String, message: String, sender: UIViewController, completion: @escaping ()->()){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
            action in completion()
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
    public static func overwriteDialog(sender: UIViewController){
        let user = ConnectionManager.udacian?.udacity.user
        
        let alert = UIAlertController(title: "Warning", message:  "User \"\(user?.firstName ?? "") \(user?.lastName ?? "")\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {action in
            DispatchQueue.main.async {
                sender.performSegue(withIdentifier: "addLocation", sender: sender)
            }
        }))
        
        sender.present(alert, animated: true, completion: nil)
    }
}

