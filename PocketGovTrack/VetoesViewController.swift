//
//  VetoesViewController.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 10/2/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

class VetoesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var sharedData = SharedBillData()
    var items = [BillModel]()
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        APIManager.sharedInstance.getVetoes(sharedData.date!, onCompletion: { (json: JSON) in
            if let results = json["objects"].array {
                for entry in results {
                    self.items.append(BillModel(json: entry))
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        let veto = self.items[indexPath.row]
        
        cell!.textLabel?.text = veto.title
        return cell!
    }
}
