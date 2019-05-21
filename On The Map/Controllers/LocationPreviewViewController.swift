//
//  LocationPreviewViewController.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationPreviewViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var location : CLPlacemark? = nil
    var website : String = ""
    

    override func viewWillAppear(_ animated: Bool) {
        updateCorners(obj: finishButton)
        
        let annotation = MKPointAnnotation()
        let user = ConnectionManager.udacian?.udacity.user
        annotation.coordinate = (location?.location!.coordinate)!
        annotation.title = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        annotation.subtitle = website
        map.addAnnotation(annotation)
    }
    
    func updateCorners(obj: UIView){
        obj.layer.cornerRadius = 5
        obj.clipsToBounds = true
    }

    @IBAction func finish(_ sender: Any) {
    }
    
}
