//
//  UserObject.swift
//  PocketGovtrack
//
//  Created by Eric Dattore on 9/30/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import Foundation

class UserObject {
    var pictureUrl: String!
    var username: String!
    
    required init(json: JSON) {
        pictureUrl = json["picture"]["medium"].stringValue
        username = json["email"].stringValue
    }
}
