//
//  GetStudentLocations.swift
//  On The Map
//
//  Created by Douglas Cooper on 4/18/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import Foundation

func getStudentLocations(completion:@escaping (([[String: AnyObject]]) -> Void)) {

    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil { // Handle error...
            return
        } else {
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, [[String : AnyObject]]>{
                    let studentLocation = json["results"]
                    DispatchQueue.main.async {
                        completion(studentLocation! as [[String: AnyObject]])
                    }
                }}catch{
                    print("error in JSONSerialization")
            }
        }
    }
    task.resume()
}
