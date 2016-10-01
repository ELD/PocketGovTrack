//
//  SenateMemberViewController.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 10/1/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

struct PassedData {
    var party: String?
    var status: String?
}

class SenateMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var passedData = PassedData()
    var items = [CongresspersonModel]()

    override func viewWillAppear(animated: Bool) {
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let current: Bool
        if passedData.status == "Current" {
            current = true
        } else {
            current = false
        }
        
        APIManager.sharedInstance.getSenators(passedData.party ?? "All", current: current) { (json: JSON) in
//            print("JSON: \(json["objects"])")
            if let results = json["objects"].array {
                for entry in results {
                    self.items.append(CongresspersonModel(json: entry))
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        let congressperson = self.items[indexPath.row]
        
        if let url = NSURL(string: APIManager.sharedInstance.imageUrl
            + String(congressperson.id) + "-200px.jpeg") {
            if let data = NSData(contentsOfURL: url) {
                cell?.imageView?.image = UIImage(data: data)
            }
        }
        
        cell!.textLabel?.text = congressperson.name
        return cell!
    }
}
