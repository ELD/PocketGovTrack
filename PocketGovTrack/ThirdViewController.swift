//
//  ThirdViewController.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 10/1/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var billTypePicker: UIPickerView!
    @IBOutlet weak var showBills: UIButton!
    
    var chambers: [String]!
    var billTypes: [String]!
    var chambersAndBillTypes: [String: [String]]!
    
    let chamberComponent = 0
    let billTypeComponent = 1
    
    var dateAfter: NSDate = NSDate()
    var chamber: String = "House of Representatives"
    var billType: String = "House Bill"

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.maximumDate = NSDate()
        dateAfter = datePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("billtypes", ofType: "plist")
        
        chambersAndBillTypes = NSDictionary(contentsOfFile: path!) as! [String: [String]]
        
        chambers = Array(chambersAndBillTypes.keys)
        billTypes = chambersAndBillTypes[chambers[0]]! as [String]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBills" {
            let vc = segue.destinationViewController as! BillViewController
            
            vc.sharedData.billType = billType
            vc.sharedData.date = dateAfter
        }
    }
    
    @IBAction func dateDidChange(sender: UIDatePicker) {
        dateAfter = datePicker.date
    }
    
    func unwrapSegue(segue: UIStoryboardSegue) {
        // Do nothing
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == chamberComponent {
            return chambers.count
        } else {
            return billTypes.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == chamberComponent {
            return chambers[row]
        } else {
            return billTypes[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == chamberComponent {
            let selectedChamber = chambers[row]
            billTypes = chambersAndBillTypes[selectedChamber]
            billTypePicker.reloadComponent(billTypeComponent)
            billTypePicker.selectRow(0, inComponent: billTypeComponent, animated: true)
        }
        
        billType = billTypes[pickerView.selectedRowInComponent(billTypeComponent)]
    }
}
