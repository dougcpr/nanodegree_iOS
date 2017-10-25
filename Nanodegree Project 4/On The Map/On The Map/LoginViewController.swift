//
//  ViewController.swift
//  On The Map
//
//  Created by Douglas Cooper on 2/7/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostLinkViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    @IBAction func registrationButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, completionHandler: nil)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        verifyUser(username: userNameTextField.text ?? String(), password: passwordTextField.text ?? String())
        }
    
    // Subscribe to keyboard notifications. It will add an observer to the keyboardWillShow function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow  , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Get and use keyboard height. This sets the keyboard height to negative because
    // when the screen rotates the lifecycle will subscribe again.
    // using -= will shift it up a second time, so you have to multiply by negative 1 to
    // keep the height consistent distance from the origin
    func keyboardWillShow(_ notification: Notification) {
        
        //if editing is started in bottom textfield, frame moves up to avoid textfield being covered by the keyboard, if not already moved up
        if passwordTextField.isFirstResponder && view.frame.origin.y == 0 {
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
        if passwordTextField.isFirstResponder && view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}
