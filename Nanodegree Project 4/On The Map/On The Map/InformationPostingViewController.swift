//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Douglas Cooper on 5/1/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var onTheMapTextField: UITextField!
    @IBOutlet weak var findOnTheMap: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let background = UIColor (colorLiteralRed: 0, green: 100, blue: 77.6, alpha: 1)
        
        findOnTheMap.backgroundColor = background
        findOnTheMap.layer.cornerRadius = 10
        findOnTheMap.layer.borderWidth = 1
        findOnTheMap.layer.borderColor = UIColor.clear.cgColor
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func CancelPinPost(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnTheMap(_ sender: Any) {
        let address = onTheMapTextField.text ?? String()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let linkViewController = storyBoard.instantiateViewController(withIdentifier: "SetupLinkController") as! PostLinkViewController
        linkViewController.address = address
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.alertIncorrectAddress()
            }
            if let placemark = placemarks?.first {
                linkViewController.latitude = (placemark.location?.coordinate.latitude)!
                linkViewController.longitude = (placemark.location?.coordinate.longitude)!
                self.present(linkViewController, animated: true, completion: nil)
            }
        })
    }
    
    func alertIncorrectAddress() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Incorrect Address", message:
                "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Unsubscribe from keybaord notitfications It will add an observer to the keyboardWillHide function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Subscribe to keyboard notifications. It will add an observer to the keyboardWillShow function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(InformationPostingViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow  , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InformationPostingViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Get and use keyboard height. This sets the keyboard height to negative because
    // when the screen rotates the lifecycle will subscribe again.
    // using -= will shift it up a second time, so you have to multiply by negative 1 to
    // keep the height consistent distance from the origin
    func keyboardWillShow(_ notification: Notification) {
        
        //if editing is started in bottom textfield, frame moves up to avoid textfield being covered by the keyboard, if not already moved up
        if onTheMapTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    // gets the keyboard height by looking at the observable
    // returns the keyboard's height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func keyboardWillHide(_ notification: Notification) {
        if onTheMapTextField.isFirstResponder && view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

}
