//
//  FirstViewController.swift
//  PocketGovtrack
//
//  Created by Eric Dattore on 9/30/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var limitSlider: UISlider!
    @IBOutlet weak var limitLabel: UILabel!
    
    let parties: [String] = [
        "All",
        "Democrat",
        "Republican",
        "Independent"
    ]
    
    let status: [String] = [
        "Current",
        "Former"
    ]
    
    var selectedParty = "All"
    var selectedStatus = "Current"
    var limit: Int = -1
    
    override func viewWillAppear(animated: Bool) {        
        limitLabel.text = "Result limit: " + String(Int(limitSlider.value))
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.parties.count
        } else {
            return self.status.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.parties[row]
        } else {
            return self.status[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedParty = self.parties[pickerView.selectedRowInComponent(0)]
        selectedStatus = self.status[pickerView.selectedRowInComponent(1)]
    }
    
    @IBAction func sliderLimitDidChange(sender: UISlider) {
        self.limit = Int(limitSlider.value)
        
        limitLabel.text = "Result limit: " + String(Int(limitSlider.value))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSenateMembers" {
            let vc = segue.destinationViewController as! SenateMemberViewController
            
            vc.passedData.party = selectedParty
            vc.passedData.status = selectedStatus
            vc.passedData.limit = limit
        }
    }
    
    
    @IBAction func unwindSenateMemberView(segue: UIStoryboardSegue) {
        if segue.identifier == "showSenateMembers" {
            let vc = segue.sourceViewController as! SenateMemberViewController
            
            limitSlider.value = Float(vc.passedData.limit!)
        }
    }
}

