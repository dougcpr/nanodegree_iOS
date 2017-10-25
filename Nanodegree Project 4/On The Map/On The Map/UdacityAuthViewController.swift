//
//  UdacityAuthViewController.swift
//  On The Map
//
//  Created by Douglas Cooper on 2/8/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject {

let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Accept")
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"udacity\": {\"username\": \(userNameTextField.text), \"password\": \(passwordTextField.text)}}".data(using: String.Encoding.utf8)
request.httpBody = "{\"udacity\": {\"username\": \"\(userNameTextField.text ?? String())\", \"password\": \"\(passwordTextField.text ?? String())\"}}".data(using: String.Encoding.utf8)
let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { data, response, error in
    if error != nil { // Handle error…
        return
    }
    
    func sendError(_ error: String) {
        print(error)
    }
    
    /* GUARD: Was there an error? */
    guard (error == nil) else {
        sendError("There was an error with your request: \(error)")
        return
    }
    
    /* GUARD: Did we get a successful 2XX response? */
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        sendError("Your request returned a status code other than 2xx!")
        return
    }
    
    /* GUARD: Was there any data returned? */
    guard let data = data else {
        sendError("No data was returned by the request!")
        return
    }
    
    let range = Range(uncheckedBounds: (5, data.count - 5))
    let newData = data.subdata(in: range) /* subset response data! */
    print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
}
}


task.resume()
}
