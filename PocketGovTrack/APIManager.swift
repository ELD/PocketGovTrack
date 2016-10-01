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
    let imageUrl = "https://www.govtrack.us/data/photos/"
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
        let route = baseUrl
        makeHttpGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON) })
    }
    
    func getSenators(party: String, current: Bool, onCompletion: (JSON) -> Void) {
        var route =
            congressBaseUrl + "?role_type=senator"
                + "&current=" + String(current)
                
        if party != "All" {
            route += "&party=" + party
        }
        
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
    
    private func makeHttpPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            onCompletion(nil, nil)
        }
    }
}
