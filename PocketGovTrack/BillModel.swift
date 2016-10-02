//
//  BillModel.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 10/1/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import Foundation

class BillModel {
    var title: String
    
    required init(json: JSON) {
        title = json["title"].stringValue
    }
}
