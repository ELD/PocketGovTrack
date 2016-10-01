//
//  CongressmanModel.swift
//  PocketGovTrack
//
//  Created by Eric Dattore on 9/30/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import Foundation

class CongresspersonModel {
    var name: String!
    var party: String!
    var leadershipRole: String?
    var id: Int
    
    required init(json: JSON) {
        name = json["person"]["name"].stringValue
        party = json["party"].stringValue
        leadershipRole = json["leadership_title"].string
        id = json["person"]["id"].intValue
    }
}
