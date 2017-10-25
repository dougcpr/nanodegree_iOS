//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let request = NSMutableURLRequest(url: URL(string: "http://apps.tsa.dhs.gov/MyTSAWebService/GetTSOWaitTimes.ashx")!)
request.httpMethod = "GET"
let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { data, response, error in
    if error != nil { // Handle error…
        return
    }
    
}
task.resume()
