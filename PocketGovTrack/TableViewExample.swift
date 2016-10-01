//
//  FirstViewController.swift
//  PocketGovtrack
//
//  Created by Eric Dattore on 9/30/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var items = [UserObject]()
    
    override func viewWillAppear(animated: Bool) {
        let frame: CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let btn = UIButton(frame: CGRect(x: 0, y:25, width: self.view.frame.width, height: 50))
        btn.backgroundColor = UIColor.cyanColor()
        btn.setTitle("Add new Dummy", forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(ExampleViewController.addDummyData), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
    }
    
    func addDummyData() {
        APIManager.sharedInstance.getRandomUser { (json: JSON) in
            if let results = json["results"].array {
                for entry in results {
                    self.items.append(UserObject(json: entry))
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
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
        
        let user = self.items[indexPath.row]
        
        if let url = NSURL(string: user.pictureUrl) {
            if let data = NSData(contentsOfURL: url) {
                cell?.imageView?.image = UIImage(data: data)
            }
        }
        
        cell!.textLabel?.text = user.username
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

