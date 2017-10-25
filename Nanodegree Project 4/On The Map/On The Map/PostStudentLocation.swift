//
//  PostStudentLocation.swift
//  On The Map
//
//  Created by Douglas Cooper on 5/4/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import Foundation

func postStudentLocation(mediaUrl: String, address: String, longitude: Double, latitude: Double, firstName: String, lastName: String){
    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
    request.httpMethod = "POST"
    
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(address)\", \"mediaURL\": \"\(mediaUrl)\", \"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil { // Handle error…
            return
        }
    }
    task.resume()
}
