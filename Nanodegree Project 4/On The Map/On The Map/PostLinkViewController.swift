//
//  PostLinkViewController.swift
//  On The Map
//
//  Created by Douglas Cooper on 5/1/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit
import MapKit

class PostLinkViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var mapViewVerification: MKMapView!
    
    var latitude = 0.0
    var longitude = 0.0
    var address = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMapData()
        // Do any additional setup after loading the view.
        let background = UIColor (colorLiteralRed: 0, green: 100, blue: 77.6, alpha: 1)
        
        submit.backgroundColor = background
        submit.layer.cornerRadius = 9
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.clear.cgColor
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostLinkViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Sends Student Data
    @IBAction func postStudentData(_ sender: Any) {
        postStudentLocation(mediaUrl: linkTextField.text ?? String(), address: address, longitude: longitude, latitude: latitude, firstName: studentInfo.firstName, lastName: studentInfo.lastName)
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController")
            self.present(tabBarViewController, animated: true, completion: nil)
        }
    }
    
    func loadMapData() {
        var annotations = [MKPointAnnotation]()
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Here we create the annotation and set its coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(
            coordinate, 500, 500)
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        self.mapViewVerification.addAnnotations(annotations)
        self.mapViewVerification.setRegion(region, animated: true)
    }
}
