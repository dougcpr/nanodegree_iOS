//
//  GetStudentPublicInfo.swift
//  On The Map
//
//  Created by Douglas Cooper on 5/8/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import Foundation
import UIKit

func getStudentData(key: String) {
    // 2a. Session Configuration
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let url = URL(string: "https://www.udacity.com/api/users/\(key)")!
    
    // 2b. Task Assignment
    let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
            
            print(error!.localizedDescription)
            
        }
            let range = Range(uncheckedBounds: (5, (data?.count)! - 0))
            let newData = data?.subdata(in: range) /* subset response data! */
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String: AnyObject]
                let Object = parsedData["user"]!
                
                studentInfo.firstName = (Object["first_name"] as? String)!
                studentInfo.lastName = (Object["last_name"] as? String)!
                
                
                
            } catch let error as NSError {
                print(error)
            }
    }
    /* Start the Request */
    task.resume()
}
