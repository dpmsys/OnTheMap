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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        if studentDataModified {
            studentDataModified = false
            self.tableView.reloadData()
            self.scrollToFirstRow()
            
//            self.tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MapTableViewCell {
        
        let CellReuseId = "userCell"
        let student =  Students.sharedInstance.studentArray[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as! MapTableViewCell?
        
        cell?.imageView?.image = UIImage(contentsOfFile: "icon_pin.png")
        cell?.name?.text = "\(student.firstName) \(student.lastName)"
        cell?.URL?.text = student.mediaURL
    
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Students.sharedInstance.studentArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared

        if let mediaURL = URL(string: Students.sharedInstance.studentArray[(indexPath as NSIndexPath).row].mediaURL) {
            app.open(mediaURL, options: [ : ]) { (success) in
                if (!success) {
                    self.errorAlert(message: "Invalid Link")
                }
            }
        } else {
            self.errorAlert(message: "Invalid Link")
        }
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

}
