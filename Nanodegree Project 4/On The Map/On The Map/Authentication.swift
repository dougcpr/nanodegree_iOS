//
//  Authentication.swift
//  On The Map
//
//  Created by Douglas Cooper on 2/8/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit

extension LoginViewController {
 
    func verifyUser(username: String, password: String) {
    
    /* 1. Setup URL with API Parameters */
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    
    /* 2. Declare HTTP Method and Header Values */
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    /* 3. Define the object sent in the HTTP Body */
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
    
    /* 4. Create a SHARED Network Session */
    let session = URLSession.shared
    
    /* 5. Define the DATA Task and setup GUARDS for errors */
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
        if error != nil {
            print(error!.localizedDescription)
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
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Incorrect Password or Email", message:
                    "You have entered an incorrect password or email. Try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            sendError("Your request returned a status code other than 2xx!")
            return
        }

        /* GUARD: Was there any data returned? */
        guard let data = data else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Data Issue", message:
                    "Invalid Response Object Returned", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            sendError("No data was returned by the request!")
            return
        }
        
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range) /* subset response data! */
        let response = NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!
        
        do {
            let parsedData = try JSONSerialization.jsonObject(with: newData, options: []) as! [String: AnyObject]
            let accountKey = parsedData["account"]
            studentInfo.accountKey = accountKey!["key"] as! String
            getStudentData(key: studentInfo.accountKey)
        } catch let error as NSError {
            print(error)
        }
        
        if response.contains("true") {
            DispatchQueue.main.async {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController")
                self.present(tabBarViewController, animated: true, completion: nil)
            }
        }
        
    }
    /* Start the Request */
    task.resume()
}
}
