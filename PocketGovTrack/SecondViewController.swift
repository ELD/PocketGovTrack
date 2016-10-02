//
//  SecondViewController.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 9/30/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var resultsSlider: UISlider!
    @IBOutlet weak var resultsLabel: UILabel!
    
    let parties = [
        "All",
        "Democrat",
        "Republican",
        "Independent"
    ]
    
    let status = [
        "Current",
        "Former"
    ]
    
    var selectedParty = "All"
    var selectedStatus = "Current"
    var limit = -1
    
    override func viewWillAppear(animated: Bool) {
        resultsLabel.text = "Results Limit: " + String(Int(resultsSlider.value))
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return parties.count
        } else {
            return status.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return parties[row]
        } else {
            return status[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedParty = self.parties[pickerView.selectedRowInComponent(0)]
        selectedStatus = self.status[pickerView.selectedRowInComponent(1)]
    }
    
    @IBAction func limitDidChange(sender: UISlider) {
        limit = Int(resultsSlider.value)
        resultsLabel.text = "Results Limit: " + String(Int(resultsSlider.value))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHouseMembers" {
            let vc = segue.destinationViewController as! HouseMemberViewController
            
            vc.passedData.party = selectedParty
            vc.passedData.status = selectedStatus
            vc.passedData.limit = limit
        }
    }
    
    @IBAction func unwindSenateMemberView(segue: UIStoryboardSegue) {
        if segue.identifier == "showSenateMembers" {
            let vc = segue.sourceViewController as! SenateMemberViewController
            
            resultsSlider.value = Float(vc.passedData.limit!)
        }
    }
}

