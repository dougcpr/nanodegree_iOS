//
//  MapTableViewController.swift
//  On The Map
//
//  Created by Douglas Cooper on 4/25/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit

class MapTableViewController: UITableViewController {
    
    var names = [String]()
    var links = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func loadStudentData() {
    
        getStudentLocations {(data) in
            for dictionary in data {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                if let tempFirst = dictionary["firstName"] as? String, let tempLast = dictionary["lastName"] as? String, let tempMedia = dictionary["mediaURL"] as? String{
                    let first = tempFirst
                    let last = tempLast
                    let mediaUrl = tempMedia
                    
                    self.names.append(first + " " + last)
                    self.links.append(mediaUrl)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as? MapTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MapTableViewCell.")
        }
        
        DispatchQueue.main.async {
            let map = self.names[indexPath.row]
            cell.studentName.text = map
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            UIApplication.shared.open(URL(string: self.links[indexPath.row])!)
    }
    
    
    @IBAction func setupPinInformation(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pinViewController = storyBoard.instantiateViewController(withIdentifier: "SetupPinController")
        self.present(pinViewController, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        deleteStudentSessionInfo()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController, animated: true, completion: nil)
    }

    @IBAction func refreshButton(_ sender: Any) {
        self.tableView.reloadData()
    }
    
}
