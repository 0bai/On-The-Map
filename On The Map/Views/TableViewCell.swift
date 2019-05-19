//
//  TableViewCell.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var address:StudentInformation! {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var pin: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    func updateUI(){
        if address != nil {
            setIcon(isLoading: false)
        }else{
            setIcon(isLoading: true)
        }
        
            nameLabel.text = "\((address?.firstName ?? "Loading")!) \((address?.lastName ?? "")!)"
            websiteLabel.text = "\((address?.website ?? "Loading")!)"
        
    }
    
    func setIcon(isLoading: Bool){
        if isLoading{
            pin.isHidden = true
            activityIndicator.startAnimating()
        }else{
            pin.isHidden = false
            activityIndicator.stopAnimating()
        }
        
    }
    
}
