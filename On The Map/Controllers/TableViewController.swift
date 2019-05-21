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
    
    override func viewWillAppear(_ animated: Bool) {
        
        ConnectionManager.connectionDelegate = self
        
        if OnTheMapAPI.studentsLocation == nil {
            refresh(self)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        OnTheMapAPI.studentsLocation = nil
        updateTable()
        retrieveData()
    }
    @IBAction func logout(_ sender: Any) {
        ConnectionManager.logout()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapAPI.studentsLocation?.results.count ?? 100
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        let student = OnTheMapAPI.studentsLocation?.results[indexPath.row]
        
        cell.address = student ?? nil
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        guard let link = cell.websiteLabel.text else{ return }
        if ConnectionManager.isValidURL(link: link){
            let websiteURL = URL(string: link)!
            UIApplication.shared.open(websiteURL)
            return
        }
        DispatchQueue.main.async {
            Alert.show(title: "Error", message: "Invalid Link", sender: self, completion: {return})
        }
        
    }
    
    func serverError(error: String, details: String) {
        DispatchQueue.main.async {
            Alert.show(title: error, message: details, sender: self, completion: {return})
        }
    }
    
    func logoutSucceeded() {
        print("logout succeeded")
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
            self.present( vc, animated: true, completion: nil)
        }
    }
    
    func listRetrieved() {
        self.updateTable()
    }
    
    func retrieveData(){
        ConnectionManager.getLocations()
    }
    
    func updateTable(){
        DispatchQueue.main.async {
            
            self.tableView.beginUpdates()
            self.tableView.reloadData()
            self.tableView.endUpdates()
            
        }
    }
}
