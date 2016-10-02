//
//  FourthViewController.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 10/2/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date = NSDate()
    
    override func viewWillAppear(animated: Bool) {
        date = datePicker.date
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVetoes" {
            let vc = segue.destinationViewController as! VetoesViewController
            
            vc.sharedData.date = date
        }
    }
    
    @IBAction func unwindVetoesSegue(segue: UIStoryboardSegue) {
        // Do nothing
    }
}
