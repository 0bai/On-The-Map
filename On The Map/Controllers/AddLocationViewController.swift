//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    let segueIdentifier = "showLocation"
    var website : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCorners(obj: addressTextField)
        updateCorners(obj: websiteTextField)
        updateCorners(obj: findButton)
    }
    
    func updateCorners(obj: UIView){
        obj.layer.cornerRadius = 5
        obj.clipsToBounds = true
    }
    
    @IBAction func find(_ sender: Any) {
        
        do{
            
            guard let address =  addressTextField.text, !address.isEmpty else {
                throw InputError.empty(field: "Address")
            }
            
            website =  websiteTextField.text!
            
            guard !website!.isEmpty else {
                throw InputError.empty(field: "Website")
            }
            
            guard ConnectionManager.isValidURL(link: website!) else {
                throw InputError.invalidURL(field: "Website")
            }
            
            CLGeocoder().geocodeAddressString(address, completionHandler: { placemark, error in
                
                if error != nil {
                    
                    DispatchQueue.main.async {
                        Alert.show(title: "Location Not Found", message: "Could Not Geocode the String!", sender: self, completion: {return})
                    }
                    
                }else{
                    
                    if let location = placemark {
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: self.segueIdentifier, sender: location)
                        }
                        
                    }
                }
            })
            
        }catch InputError.invalidURL{
            
            Alert.show(title: "Invalid Website", message: "Please enter a valid website (must contain HTTP(s)://)", sender: self, completion: {return})
            return
            
        }catch InputError.empty(let field){
            
            Alert.show(title: "Empty \(field)", message: "Please Enter Your \(field)", sender: self, completion: {return})
            return
            
        }catch{
            
            let error = NSError()
            Alert.show(title: "\(error.code)" , message: error.localizedDescription, sender: self, completion: {return})
            return
            
        }
        
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.segueIdentifier{
            
            let vc = segue.destination as! LocationPreviewViewController
            
            if let placemark = (sender as! [CLPlacemark]).first {
                
                vc.location = placemark
                vc.website = website!
                vc.pinName = addressTextField.text!
                
            }
        }
    }
}
