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
    
     var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        ConnectionManager.connectionDelegate = self
        
        if OnTheMapAPI.studentsLocation == nil {
            refresh(self)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        indicatorView.isHidden = false
        mapView.removeAnnotations(annotations)
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
            self.updateMap()
        }
    }
    
    func serverError(error: String, details: String) {
        DispatchQueue.main.async {
            Alert.show(title: error, message: details, sender: self, completion: {
                self.indicatorView.isHidden = true
                return
            })
        }
    }
    
    func retrieveData(){
        ConnectionManager.getLocations()
    }
    
    func updateMap(){
        let locations = OnTheMapAPI.studentsLocation?.results
        
        annotations = [MKPointAnnotation]()
        
        locations?.forEach{ location in
            
            guard let userLat = location.latitude else {return}
            guard let userLong = location.longitude else {return}
            let lat = CLLocationDegrees(userLat)
            let long = CLLocationDegrees(userLong)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
            annotation.subtitle = location.website
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let link = view.annotation?.subtitle else{ return }
            if ConnectionManager.isValidURL(link: link!){
                let websiteURL = URL(string: link!)!
                UIApplication.shared.open(websiteURL)
                return
            }
            DispatchQueue.main.async {
                Alert.show(title: "Error", message: "Invalid Link", sender: self, completion: {return})
            }
            
        }
    }
}
