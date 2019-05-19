//
//  MapViewController.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate, ConnectionDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectionManager.connectionDelegate = self
        
        if OnTheMapAPI.studentsLocation == nil {
            refresh(self)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        indicatorView.isHidden = false
        retrieveData()
    }
    @IBAction func logout(_ sender: Any) {
        ConnectionManager.logout()
    }
    
    
    func logoutSucceeded() {
        print("logout succeeded")
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
            self.present( vc, animated: true, completion: nil)
        }
    }
    
    func listRetrieved() {
        DispatchQueue.main.async {
            self.indicatorView.isHidden = true
        }
    }
    
    func serverError(error: String) {
        DispatchQueue.main.async {
            Alert.show(title: "Download Failed", message: "Please Refresh The Table", sender: self)
        }
    }
    
    func retrieveData(){
        ConnectionManager.getLocations()
    }
    
    func updateMap(){
        DispatchQueue.main.async {
            
        }
    }
}
