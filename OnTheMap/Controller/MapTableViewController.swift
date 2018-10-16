//
//  MapTableViewController.swift
//  OnTheMap
//
//  Created by David Mulvihill on 6/26/18.
//  Copyright © 2018 David Mulvihill. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewController:  UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MapTableViewCell {
        
        let CellReuseId = "userCell"
        let user =  MapPins[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as! MapTableViewCell?
       
        let firstname = user[ParseClient.JSONResponseKeys.StudentFirstName] as! String
        let lastname = user[ParseClient.JSONResponseKeys.StudentLastName] as! String
        let userURL = user[ParseClient.JSONResponseKeys.StudentMediaURL] as! String
        
        cell?.imageView?.image = UIImage(contentsOfFile: "icon_pin.png")
        cell?.name?.text = "\(firstname) \(lastname)"
        cell?.URL?.text = userURL
    
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MapPins.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        if let userURL = MapPins[(indexPath as NSIndexPath).row][ParseClient.JSONResponseKeys.StudentMediaURL] {
            app.open(URL(string:userURL as! String)!,options: [ : ]) { (success) in
                if (!success) {
                    let alert = UIAlertController(title: nil, message: "Invalid Link", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
}
