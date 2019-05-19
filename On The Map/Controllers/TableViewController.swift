//
//  TableViewController.swift
//  On The Map
//
//  Created by Obai Alnajjar on 5/15/19.
//  Copyright © 2019 Obai Alnajjar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, ConnectionDelegate {
    
    
    
    
    let cellIdentifier = "addressCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if OnTheMapAPI.studentsLocation == nil {
            retrieveData()
        }else{
            
        }
        
    }
    
    @IBAction func refresh(_ sender: Any) {
    }
    @IBAction func logout(_ sender: Any) {
        ConnectionManager.logout()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapAPI.studentsLocation?.results.count ?? 0
    }
    
    func serverError(error: String) {
        
    }
    
    func logoutSucceeded() {
        print("logout succeeded")
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
            self.present( vc, animated: true, completion: nil)
        }
    }
    
    func listRetrieved() {
        self.refresh(self)
    }
    
    func retrieveData(){
        ConnectionManager.connectionDelegate = self
        ConnectionManager.getLocations()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        let student = OnTheMapAPI.studentsLocation?.results[indexPath.row]
        
        cell.nameLabel.text = "\(student!.firstName) \(student!.lastName)"
        
        cell.websiteLabel.text = student!.website


        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let websiteURL = URL(string: cell.websiteLabel.text!)!
        UIApplication.shared.open(websiteURL)
    }
}
