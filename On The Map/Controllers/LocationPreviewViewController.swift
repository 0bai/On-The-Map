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

class LocationPreviewViewController: UIViewController, ConnectionDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var location : CLPlacemark? = nil
    var website : String = ""
    var pinName : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        ConnectionManager.connectionDelegate = self
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
        let user = ConnectionManager.udacian?.udacity
        
        ConnectionManager.postLocation(location: StudentInformation(id: "", key: user?.credentials?.account?.id, firstName: user?.user?.firstName, lastName: user?.user?.lastName, geocode: pinName, website: website, latitude: Float((location?.location?.coordinate.latitude)!), longitude: Float((location?.location?.coordinate.longitude)!)))
    }
    
    func locationPosted() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension LocationPreviewViewController{
    // MARK: - Connection Delegate
    
    func serverError(error: String, details: String) {
        DispatchQueue.main.async {
            Alert.show(title: "Server Error", message: "Could Not Post Location, Please Try Again", sender: self, completion: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

extension LocationPreviewViewController{
    //MARK: - MKMapViewDelegate
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        let region = MKCoordinateRegion(center: (location?.location!.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.map.setRegion(region, animated: true)
    }
    
}
