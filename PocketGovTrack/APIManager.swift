//
//  APIManager.swift
//  PocketGovtrack
//
//  Created by Eric Dattore on 9/30/16.
//  Copyright © 2016 BuilDev Software. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    let baseUrl = "https://www.govtrack.us/api/v2/role?current=true&role_type=senator"
    let congressBaseUrl = "https://www.govtrack.us/api/v2/role"
    let billBaseRoute = "https://www.govtrack.us/api/v2/bill"
    let imageUrl = "https://www.govtrack.us/data/photos/"
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
        let route = baseUrl
        makeHttpGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON) })
    }
    
    func getSenators(party: String, current: Bool, limit: Int, onCompletion: (JSON) -> Void) {
        var route =
            congressBaseUrl + "?limit=100&role_type=senator"
                + "&current=" + String(current)
                
        if party != "All" {
            route += "&party=" + party
        }
        
        if limit != -1 {
            route += "&limit=" + String(limit)
        }
        
        makeHttpGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON) })
    }
    
    func getRepresentatives(party: String, current: Bool, limit: Int, onCompletion: (JSON) -> Void) {
        var route =
            congressBaseUrl + "?limit=435&role_type=representative"
                + "&current=" + String(current)
        
        if party != "All" {
            route += "&party=" + party
        }
        
        if limit != -1 {
            route += "&limit=" + String(limit)
        }
        
        makeHttpGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON) })
    }
    
    func getBills(resolutionType: String, dateAfter: NSDate, onCompletion: (JSON) -> Void) {
        var route =
            billBaseRoute + "?sort=-current_status_date"
        
        switch resolutionType {
            case "House Bill":
                route += "&bill_type=house_bill"
            break
            case "House Resolution":
                route += "&bill_type=house_resolution"
            break
            case "House Concurrent Resolution":
                route += "&bill_type=house_concurrent_resolution"
            break
            case "House Joint Resolution":
                route += "&bill_type=house_joint_resolution"
            break
            case "Senate Bill":
                route += "&bill_type=senate_bill"
            break
            case "Senate Resolution":
                route += "&bill_type=senate_resolution"
            break
            case "Senate Concurrent Resolution":
                route += "&bill_type=senate_concurrent_resolution"
            break
            case "Senate Joint Resolution":
                route += "&bill_type=senate_joint_resolution"
            break
            default:
            break
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        route += "&current_status_date__gt=" + formatter.stringFromDate(dateAfter)
        
        makeHttpGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON) })
    }
    
    func getVetoes(dateAfter: NSDate, onCompletion: (JSON) -> Void) {
        var route = billBaseRoute + "?sort=-current_status_date"
        
        route += "&current_status__in="
            + "prov_kill_veto%7C"
            + "vetoed_override_fail_second_house%7C"
            + "vetoed_pocket%7C"
            + "vetoed_override_fail_originating_house%7C"
            + "vetoed_override_fail_second_senate%7C"
            + "vetoed_override_fail_originating_senate"
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        route += "&current_status_date__gt=" + formatter.stringFromDate(dateAfter)
        
        makeHttpGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON) })
    }
    
    private func makeHttpGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if let jsonData = data {
                let json: JSON = JSON(data: jsonData)
                onCompletion(json, error)
            }else {
                onCompletion(nil, error)
            }
        })
        
        task.resume()
    }
}
